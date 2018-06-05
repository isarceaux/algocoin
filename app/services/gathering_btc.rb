class GatheringBtc
  
  ROUNDING_LIMIT  = 10

  def initialize
    Poloniex.setup do | config |
      config.key = ENV['API_KEY_POLONIEX']
      config.secret = ENV['SECRET_API_KEY_POLONIEX']
    end
  end

  def perform
    btc = Currency.find_by_code("BTC")
    pairs_BTC_buy = Pair.where(first_currency_id: btc.id)
    # pairs_BTC_sell = Pair.where(second_currency_id: btc.id)
    balance = JSON.parse(Poloniex.balances)

    pairs_BTC_buy.each do |pair|
      amount = balance[pair.second_currency.code]
      if amount.to_f > 0.01
        pair_string = '' + pair.first_currency.code + '_' + pair.second_currency.code
        puts pair_string.to_s
        puts amount.to_s
        rate = JSON.parse(Poloniex.order_book(pair_string).body)["bids"][9][0].to_f
        #Rounding to be able to process order
        # rate.to_f.round(ROUNDING_LIMIT).to_s
        # amount.to_f.round(ROUNDING_LIMIT).to_s
        puts rate.to_s
        begin
          trade = Poloniex.sell(pair_string.to_s, rate.to_s, amount.to_s)
          puts JSON.parse(trade)
        rescue
          puts "Trade could not pass"
        end
      end
    end
  
  end

end