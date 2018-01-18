class TestApi
  
  attr_accessor :resouce
  POLONIEX_URL = 'https://poloniex.com/tradingApi'
  # Ressource for testing the API https://github.com/Lowest0ne/poloniex/blob/master/lib/poloniex.rb

  def initialize
    
    Poloniex.setup do | config |
      config.key = ENV['API_KEY_POLONIEX']
      config.secret = ENV['SECRET_API_KEY_POLONIEX']
    end

    # Example to get order books
    pair_string = '' + Trio.first.first_currency.code  + '_' + Trio.first.second_currency.code
    # order_book = Poloniex.order_book(pair_string)
    # order_book_json = JSON.parse(order_book.body)
    rate = JSON.parse(Poloniex.order_book(pair_string).body)["bids"][10][0].to_f
    amount = 0.001
    Poloniex.sell(pair_string, rate, amount)

    #To check the trade history
    JSON.parse(Poloniex.open_orders(pair_string)) #If the order wasn't passed
    JSON.parse(Poloniex.trade_history( pair_string)) #If the order has passed

    binding.pry


  end

  def perform
    
  end

end