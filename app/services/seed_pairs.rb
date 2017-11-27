class SeedPairs

  URL_FIX_ZERO    = 'https://poloniex.com/public?command='
  
  def intitialize

  end

  def perform
    currencies = Currency.all
    mother_currencies_codes = ['XMR','ETH','USDT','BTC']
    mother_currencies = []

    mother_currencies_codes.each do |mc_code|
      mother_currencies << Currency.find_by_code(mc_code) 
    end

    mother_currencies.each do |mc|
      currencies.each do |c|
        puts "Paire #{mc.code} vs #{c.code}"
        json = HTTParty.get(url_build_order_book(mc.code, c.code, 10)).parsed_response
        if json.first[0]!="error" && Pair.where(first_currency:mc).where(second_currency:c)==[]
          pair                 = Pair.new
          pair.first_currency  = mc
          pair.second_currency = c
          pair.save
          puts "paire supplémentaire"
        end
      end
    end
  end

  def url_build_order_book(pair1, pair2, depth)
    return url_build('returnOrderBook&currencyPair=') + pair1 + '_' + pair2 + '&depth=' + depth.to_s
  end

  def url_build(command)
    return URL_FIX_ZERO + command
  end

end