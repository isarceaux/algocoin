class SeedTrios

  def initialize
  end

  def perform

    mother_currencies_codes = ['XMR','ETH','USDT','BTC']
    mother_currencies = []
    mother_currencies_codes.each do |mc_code|
      mother_currencies << Currency.find_by_code(mc_code) 
    end

    # mother_currencies.each do |mc|
    #   Pair.where(first_currency:mc).pluck('currency2_code').each do |c2|
    #     Duo.where(currency1_code:c2).pluck('currency2_code').each do |c3|
    #       if Duo.where(currency1_code:mc).where(currency2_code:c3)!=[] && Trio.where(currency1_code:mc).where(currency2_code:c2).where(currency3_code:c3) == []
    #         t                = Trio.new
    #         t.currency1_code = mc
    #         t.currency2_code = c2
    #         t.currency3_code = c3
    #         t.save
    #       end
    #     end
    #   end
    # end

    mother_currencies.each do |mc|
      Pair.where(first_currency:mc).each do |pair1|
        Pair.where(first_currency:pair1.second_currency).each do |pair2|
          if Pair.where(first_currency:mc).where(second_currency:pair2.second_currency) != [] && Trio.where(first_currency:mc).where(second_currency:pair1.second_currency).where(third_currency:pair2.second_currency) == []
            new_trio                 = Trio.new
            new_trio.first_currency  = mc
            new_trio.second_currency = pair1.second_currency
            new_trio.third_currency  = pair2.second_currency
            new_trio.save
          end
        end
      end
    end
  end

end