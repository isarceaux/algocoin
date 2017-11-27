class SeedCurrencies

  URL_FIX_ZERO    = 'https://poloniex.com/public?command='

  def initialize
  end

  def perform
    currencies = HTTParty.get(url_build('returnCurrencies')).parsed_response
    currencies.each do |currency|
      cnew = Currency.new
      cnew.code = currency[0]
      cnew.name = currency[1]["name"]
      cnew.save
    end
  end

  def url_build(command)
    URL_FIX_ZERO + command
  end

end