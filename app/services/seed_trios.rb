class SeedTrios

  def initialize
  end

  def perform

    mother_currencies_codes = ['XMR','ETH','USDT','BTC']
    mother_currencies = []
    mother_currencies_codes.each do |mc_code|
      mother_currencies << Currency.find_by_code(mc_code) 
    end

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