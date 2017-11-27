class SeedCurrencies

  URL_FIX_ZERO    = 'https://poloniex.com/public?command='

  def initialize
  end

  def perform
    currencies = HTTParty.get(url_build('returnCurrencies')).parsed_response
    currencies.each do |currency|
      Currency.initialize(currency)
    end
  end

  def url_build(command)
    URL_FIX_ZERO + command
  end

end