class CalculatingArbitrageWorker

  include Sidekiq::Worker

  URL_FIX_ZERO = 'https://poloniex.com/public?command='
  UNIT_TEST_USDT = 1.0
  UNIT_TEST_BTC = 0.00008649

  def initialize
  end

  def perform

    trios = Trio.all
    depth = 10

    trios.each do |trio|
      
      first_order_book = getting_order_books(trio.first_currency, trio.second_currency, depth)
      second_order_book = getting_order_books(trio.second_currency, trio.third_currency, depth)
      third_order_book = getting_order_books(trio.first_currency, trio.third_currency, depth)
      ratio = (1 / first_order_book.ask_hash.last[0].to_f) * (1 / second_order_book.ask_hash.last[0].to_f) * third_order_book.bid_hash.first[0].to_f
      worst_ratio = (1 / first_order_book.ask_hash.first[0].to_f) * (1 / second_order_book.ask_hash.first[0].to_f) * third_order_book.bid_hash.last[0].to_f 
      if ratio > 1.0025
        new_arbitrage                   = Arbitrage.new
        new_arbitrage.trio              = trio
        new_arbitrage.first_order_book  = first_order_book
        new_arbitrage.second_order_book = second_order_book
        new_arbitrage.third_order_book  = third_order_book
        new_arbitrage.raw_ratio         = ratio
        new_arbitrage.worst_ratio       = worst_ratio
        new_arbitrage.save
        pass_an_order(new_arbitrage)
      else
        first_order_book.destroy
        second_order_book.destroy
        third_order_book.destroy
      end

    end
    
  end

  def pass_an_order(arbitrage)

    Sidekiq.logger.info 'We found an arbitrage and will try to pass orders'

    Poloniex.setup do | config |
      config.key = ENV['API_KEY_POLONIEX']
      config.secret = ENV['SECRET_API_KEY_POLONIEX']
    end

    # First order
    pair_string1 = '' + arbitrage.trio.first_currency.code + '_' + arbitrage.trio.second_currency.code + ''
    Sidekiq.logger.info 'Passing first order for pair #{pair_string1}'
    rate1 = arbitrage.first_order_book.ask_hash[9][0].to_f
    amount1 = 0.0
    if arbitrage.trio.first_currency.code == 'USDT'
      amount1 = UNIT_TEST_USDT / rate
    elsif arbitrage.trio.first_currency.code == 'BTC'
      amount1 = UNIT_TEST_BTC / rate
    end
    trade1 = Poloniex.buy(pair_string1, rate1, amount1)
    Sidekiq.logger.info 'First trade was attempted'
    Sidekiq.logger.info JSON.parse(trade1)

    ##Record the trade
    order_number = JSON.parse(trade1)['orderNumber'])
    if JSON.parse(Poloniex.trade_history(pair_string1)).first['orderNumber'] == order_number
      Sidekiq.logger.info 'Found the trade in History will attempt to register it'
      trade_history = JSON.parse(Poloniex.trade_history(pair_string1)).first
      record_trade(trade_history, arbitrage, arbitrage.first_order_book.pair, true)
    # Should create an elsif case when the order didn't pass but need to test it first...
    end

    # Second order
    pair_string2 = '' + arbitrage.trio.second_currency.code + '_' + arbitrage.trio.third_currency.code + ''
    Sidekiq.logger.info 'Passing second order for pair #{pair_string2}'
    rate2 = arbitrage.second_order_book.ask_hash[9][0].to_f
    amount2 = amount1 * rate
    
    trade2 = Poloniex.buy(pair_string2, rate2, amount2)
    Sidekiq.logger.info 'Second trade was attempted'
    Sidekiq.logger.info JSON.parse(trade2)

    ##Record the trade
    order_number = JSON.parse(trade2)['orderNumber'])
    if JSON.parse(Poloniex.trade_history(pair_string2)).first['orderNumber'] == order_number
      Sidekiq.logger.info 'Found the trade in History will attempt to register it'
      trade_history = JSON.parse(Poloniex.trade_history(pair_string2)).first
      record_trade(trade_history, arbitrage, arbitrage.second_order_book.pair, true)
    # Should create an elsif case when the order didn't pass but need to test it first...
    end

    # Third order
    pair_string3 = '' + arbitrage.trio.first_currency.code + '_' + arbitrage.trio.third_currency.code + ''
    Sidekiq.logger.info 'Passing second order for pair #{pair_string3}'
    rate3 = arbitrage.second_order_book.bid_hash[0][0].to_f
    amount3 = amount2 * rate3
    
    trade3 = Poloniex.buy(pair_string3, rate3, amount3)
    Sidekiq.logger.info 'Third trade was attempted'
    Sidekiq.logger.info JSON.parse(trade3)

    ##Record the trade
    order_number = JSON.parse(trade3)['orderNumber'])
    if JSON.parse(Poloniex.trade_history(pair_string3)).first['orderNumber'] == order_number
      Sidekiq.logger.info 'Found the trade in History will attempt to register it'
      trade_history = JSON.parse(Poloniex.trade_history(pair_string3)).first
      record_trade(trade_history, arbitrage, arbitrage.third_order_book.pair, true)
    # Should create an elsif case when the order didn't pass but need to test it first...
    end

  end

  def record_trade(trade_history, arbitrage, pair, passed_trade)
    trade                          = Trade.new
    trade.poloniex_global_trade_id = trade_history['globalTradeID']
    trade.poloniex_trade_id        = trade_history['tradeID']
    trade.rate                     = trade_history['rate']
    trade.amount                   = trade_history['amount']
    trade.total                    = trade_history['total']
    trade.fee                      = trade_history['fee']
    trade.poloniex_order_number    = trade_history['orderNumber']
    trade.type                     = trade_history['type']
    trade.category                 = trade_history['category']
    trade.pair                     = pair
    trade.trade_time               = trade_history['date'].to_time
    trade.arbitrage                = arbitrage
    trade.passed_trade             = passed_trade
    trade.save
    Sidekiq.logger.info 'A new trade was recorded'
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