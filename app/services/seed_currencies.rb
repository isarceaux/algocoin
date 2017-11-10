class SeedCurrencies

  URL_FIX_ZERO    = 'https://poloniex.com/public?command='

  def initialize
  end

  def perform
    currencies = HTTParty.get(url_build('returnCurrencies')).parsed_response
    currencies.each do |c|
      cnew = Currency.new
      cnew.code = c[0]
      cnew.name = c[1]["name"]
      cnew.save
    end
  end

  def url_build(command)
    return URL_FIX_ZERO + command
  end

end