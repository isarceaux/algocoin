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
    order_book = Poloniex.order_book(pair_string)
    order_book_json = JSON.parse(order_book.body)
    binding.pry

  end

  def perform
    
  end

end