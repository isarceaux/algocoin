class TestApi
  
  attr_accessor :resouce
  POLONIEX_URL = 'https://poloniex.com/tradingApi'
  # Ressource for testing the API https://github.com/Lowest0ne/poloniex/blob/master/lib/poloniex.rb

  def initialize
    
    Poloniex.setup do | config |
      config.key = ENV['API_KEY_POLONIEX']
      config.secret = ENV['SECRET_API_KEY_POLONIEX']
    end

    binding.pry

  end

  def perform
    
  end

end