class TestingResults

  def initialize

    missed_arbitrages = []
    successful_arbitrages = []

    for i in 112..123
      if Arbitrage.find(i).trades == []  
        missed_arbitrages << Arbitrage.find(i)
      else
        successful_arbitrages << Arbitrage.find(i)
      end
    end

    puts "List of successful arbitrages"
    puts "-----------------------------"
    successful_arbitrages.each do |arbitrage|
      puts "#{arbitrage.id}: " "#{arbitrage.trio.first_currency.code}" + "->" + "#{arbitrage.trio.second_currency.code}" + "->" "#{arbitrage.trio.third_currency.code}"
    end

    puts ""
    puts "List of failed arbitrages"
    puts "-----------------------------"
    missed_arbitrages.each do |arbitrage|
      puts "#{arbitrage.id}: " "#{arbitrage.trio.first_currency.code}" + "->" + "#{arbitrage.trio.second_currency.code}" + "->" "#{arbitrage.trio.third_currency.code}"
    end

  end
  
end