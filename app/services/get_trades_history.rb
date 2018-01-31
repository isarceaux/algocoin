class GetTradesHistory
  
  attr_accessor :resouce
  POLONIEX_URL = 'https://poloniex.com/tradingApi'
  # Ressource for testing the API https://github.com/Lowest0ne/poloniex/blob/master/lib/poloniex.rb

  def initialize(pair_string = 'USDT_DASH')
    
    Poloniex.setup do | config |
      config.key = ENV['API_KEY_POLONIEX']
      config.secret = ENV['SECRET_API_KEY_POLONIEX']
    end

    # Example to pass an order
    return JSON.parse(Poloniex.trade_history( pair_string)) #If the order has passed

    # binding.pry

  end

  def perform
    
  end

end