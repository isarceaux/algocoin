class SeedDuos

  URL_FIX_ZERO    = 'https://poloniex.com/public?command='
  
  def intitialize

  end

  def perform
    currencies = Currency.all.pluck('code')
    mother_currencies = ['XMR','ETH','USDT','BTC']

    mother_currencies.each do |mc|
      currencies.each do |c|
        puts "Paire #{mc} vs #{c}"
        json = HTTParty.get(url_build_order_book(mc, c, 10)).parsed_response
        if json.first[0]!="error" && Duo.where(currency1_code:mc).where(currency2_code:c)==[]
          d                = Duo.new
          d.currency1_code = mc
          d.currency2_code = c
          d.save
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