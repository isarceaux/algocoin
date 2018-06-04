class TestingResults

  def initialize(first_id,last_id)

    missed_arbitrages = []
    successful_arbitrages = []
    winning_shitcoins = []
    losing_shitcoins = []

    for i in first_id..last_id
      if Arbitrage.find(i).trades == []  
        missed_arbitrages << Arbitrage.find(i)
        losing_shitcoins << Arbitrage.find(i).trio.third_currency.code
      else
        successful_arbitrages << Arbitrage.find(i)
        winning_shitcoins << Arbitrage.find(i).trio.third_currency.code
      end
    end

    

    puts "List of successful arbitrages"
    puts "-----------------------------"
    successful_arbitrages.each do |arbitrage|
      puts "#{arbitrage.id}: " "#{arbitrage.trio.first_currency.code}" + "->" + "#{arbitrage.trio.second_currency.code}" + "->" "#{arbitrage.trio.third_currency.code}"
    end
    puts winning_shitcoins.sort

    puts ""
    puts "List of failed arbitrages"
    puts "-----------------------------"
    missed_arbitrages.each do |arbitrage|
      puts "#{arbitrage.id}: " "#{arbitrage.trio.first_currency.code}" + "->" + "#{arbitrage.trio.second_currency.code}" + "->" "#{arbitrage.trio.third_currency.code}"
    end
    puts losing_shitcoins.sort

    # binding.pry()

  end
  
end