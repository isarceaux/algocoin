class MakingArbitrageWorker

  include Sidekiq::Worker

  attr_accessor :first_trade_successful, :second_trade_successful, :third_trade_successful

  URL_FIX_ZERO    = 'https://poloniex.com/public?command='
  UNIT_TEST_USDT  = 2.0
  UNIT_TEST_BTC   = 0.00017
  TRANSACTION_FEE = 0.0025
  ROUNDING_LIMIT  = 10

  def initialize
    Poloniex.setup do | config |
      config.key = ENV['API_KEY_POLONIEX']
      config.secret = ENV['SECRET_API_KEY_POLONIEX']
    end
    @first_trade_successful = false
    @second_trade_successful = false
    @third_trade_successful = false
  end

  def perform(ratio_value) # ratio_value > 1.0025 #Condition to be used in production

    trios = Trio.where(first_currency_id:35) #We use only trios starting with BTC to make BTC only :)
    depth = 10

    trios.shuffle.each do |trio| 
      
      first_order_book = getting_order_books(trio.first_currency, trio.second_currency, depth)
      second_order_book = getting_order_books(trio.second_currency, trio.third_currency, depth)
      third_order_book = getting_order_books(trio.first_currency, trio.third_currency, depth)
      ratio = (1 / first_order_book.ask_hash.last[0].to_f) * (1 / second_order_book.ask_hash.last[0].to_f) * third_order_book.bid_hash.first[0].to_f
      worst_ratio = (1 / first_order_book.ask_hash.first[0].to_f) * (1 / second_order_book.ask_hash.first[0].to_f) * third_order_book.bid_hash.last[0].to_f 
      if ratio > ratio_value 
        new_arbitrage                   = Arbitrage.new
        new_arbitrage.trio              = trio
        new_arbitrage.first_order_book  = first_order_book
        new_arbitrage.second_order_book = second_order_book
        new_arbitrage.third_order_book  = third_order_book
        new_arbitrage.raw_ratio         = ratio
        new_arbitrage.worst_ratio       = worst_ratio
        new_arbitrage.save
        make_arbitrage(new_arbitrage)
        if @first_trade_successful && @second_trade_successful && @third_trade_successful
          record_trades_of_arbitrage(new_arbitrage)
        end
      else
        first_order_book.destroy
        second_order_book.destroy
        third_order_book.destroy
      end

      # binding.pry #For testing reasons only

    end
    
  end

  def make_arbitrage(arbitrage)

    Sidekiq.logger.info 'We found an arbitrage and will try to pass orders'

    @first_trade_successful = false
    @second_trade_successful = false
    @third_trade_successful = false

    # Starting point
    amount0 = 0.0 #For safety reasons
    if arbitrage.trio.first_currency.code == 'USDT'
      amount0 = UNIT_TEST_USDT
    elsif arbitrage.trio.first_currency.code == 'BTC'
      amount0 = UNIT_TEST_BTC
    end

    # First order
    pair_string1 = '' + arbitrage.trio.first_currency.code + '_' + arbitrage.trio.second_currency.code + ''
    rate1 = arbitrage.first_order_book.ask_hash[0][0].to_f
    amount1 = amount0 / rate1
    Sidekiq.logger.info "Passing first order for pair #{pair_string1}, rate #{rate1}, amount #{amount1}"
    @first_trade_successful = trade(pair_string1, rate1.round(ROUNDING_LIMIT), amount1.round(ROUNDING_LIMIT), "buy")

    # Second order
    if @first_trade_successful
      pair_string2 = '' + arbitrage.trio.second_currency.code + '_' + arbitrage.trio.third_currency.code + ''
      rate2 = arbitrage.second_order_book.ask_hash[0][0].to_f
      amount2 = (amount1*(1-TRANSACTION_FEE)) / rate2
      Sidekiq.logger.info "Passing second order for pair #{pair_string2}, rate #{rate2}, amount #{amount2}"
      @second_trade_successful = trade(pair_string2, rate2.round(ROUNDING_LIMIT), amount2.round(ROUNDING_LIMIT), "buy")
    end

    # Third order
    if @first_trade_successful && @second_trade_successful
      pair_string3 = '' + arbitrage.trio.first_currency.code + '_' + arbitrage.trio.third_currency.code + ''
      rate3 = arbitrage.third_order_book.bid_hash[9][0].to_f
      amount2r = amount2*(1-TRANSACTION_FEE)
      Sidekiq.logger.info "Passing third order for pair #{pair_string3}, rate #{rate3}, amount #{amount2r}"
      @third_trade_successful = trade(pair_string3, rate3.round(ROUNDING_LIMIT), amount2r.round(ROUNDING_LIMIT), "sell")
    end

  end

  def trade(pair_string, rate, amount, buy_sell)
    success_or_not = false
    begin
      trade = ""
      if buy_sell == "buy"
        trade = Poloniex.buy(pair_string.to_s, rate.to_s, amount.to_s)
      elsif buy_sell == "sell"
        trade = Poloniex.sell(pair_string.to_s, rate.to_s, amount.to_s)
      end
      trade_info       = {}
      trade_histo_info = {}
      trade_info       = JSON.parse(trade)
      trade_histo_info = JSON.parse(Poloniex.trade_history(pair_string)).first
      Sidekiq.logger.info "Following trade attempted:#{trade_info}"
      Sidekiq.logger.info "Matching trade history:#{trade_histo_info}"
      success_or_not = trade_histo_info["orderNumber"] == trade_info["orderNumber"]
    rescue
      Sidekiq.logger.info "Trade could not pass"
      trade_info       = JSON.parse(trade)
      Sidekiq.logger.info "Following trade failed:#{trade_info}"
    end
    return success_or_not
  end

  def record_trades_of_arbitrage(arbitrage)
    record_trade(arbitrage.first_order_book.pair, arbitrage, @first_trade_successful)
    record_trade(arbitrage.second_order_book.pair, arbitrage, @second_trade_successful)
    record_trade(arbitrage.third_order_book.pair, arbitrage, @third_trade_successful)
  end

  def record_trade(pair, arbitrage, passed_trade = true)
    pair_string = '' + pair.first_currency.code + '_' + pair.second_currency.code
    begin
      trade_history                  = JSON.parse(Poloniex.trade_history(pair_string)).first
      trade                          = Trade.new
      trade.poloniex_global_trade_id = trade_history['globalTradeID'].to_i
      trade.poloniex_trade_id        = trade_history['tradeID'].to_i
      trade.rate                     = trade_history['rate'].to_f
      trade.amount                   = trade_history['amount'].to_f
      trade.total                    = trade_history['total'].to_f
      trade.fee                      = trade_history['fee'].to_f
      trade.poloniex_order_number    = trade_history['orderNumber']
      trade.buy_or_sell              = trade_history['type']
      trade.category                 = trade_history['category']
      trade.pair                     = pair
      trade.trade_time               = trade_history['date'].to_time
      trade.arbitrage                = arbitrage
      trade.passed_trade             = passed_trade
      trade.save
      Sidekiq.logger.info 'A new trade was well recorded'
    rescue
      trade                          = Trade.new
      trade.pair                     = pair
      trade.trade_time               = Time.now
      trade.arbitrage                = arbitrage
      trade.passed_trade             = passed_trade
      trade.save
    end
  end

  def getting_order_books(first_currency, second_currency, depth)
    
    order_book_json         = HTTParty.get(url_build_order_book(first_currency.code, second_currency.code,depth)).parsed_response  
    new_order_book          = OrderBook.new
    new_order_book.pair     = Pair.where(first_currency:first_currency).where(second_currency:second_currency)[0]
    new_order_book.depth    = depth
    new_order_book.ask_hash = order_book_json["asks"]
    new_order_book.bid_hash = order_book_json["bids"]
    new_order_book.save

    return new_order_book

  end

  def url_build_order_book( pair1 , pair2 , depth )
    return url_build('returnOrderBook&currencyPair=') + pair1 + '_' + pair2 + '&depth=' + depth.to_s
  end

  def url_build( command )
    return URL_FIX_ZERO + command
  end

end