class WorstRatioCalculation
  
  def initialize

  end

  def perform
    worst_ratio = 0
    Arbitrage.all.each do |arbitrage|
      if arbitrage.first_order_book && arbitrage.second_order_book && arbitrage.third_order_book
        worst_ratio = 1/arbitrage.first_order_book.ask_hash.first[0].to_f * 1/arbitrage.second_order_book.ask_hash.first[0].to_f * arbitrage.third_order_book.bid_hash.last[0].to_f 
        arbitrage.worst_ratio = worst_ratio
        arbitrage.save
      end
    end
  end

end