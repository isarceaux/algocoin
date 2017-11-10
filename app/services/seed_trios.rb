class SeedTrios

  def initialize
  end

  def perform

    mother_currencies = ['XMR','ETH','USDT','BTC']

    mother_currencies.each do |mc|
      Duo.where(currency1_code:mc).pluck('currency2_code').each do |c2|
        Duo.where(currency1_code:c2).pluck('currency2_code').each do |c3|
          if Duo.where(currency1_code:mc).where(currency2_code:c3)!=[] && Trio.where(currency1_code:mc).where(currency2_code:c2).where(currency3_code:c3) == []
            t                = Trio.new
            t.currency1_code = mc
            t.currency2_code = c2
            t.currency3_code = c3
            t.save
          end
        end
      end
    end

  end

end