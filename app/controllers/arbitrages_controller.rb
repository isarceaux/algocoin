class ArbitragesController < ApplicationController

  def index
    @arbitrage_count = Arbitrage.all.count
    @order_book_count = OrderBook.all.count
    @barrier = 0.9
    @arbitrage_selection = Arbitrage.where("raw_ratio > ?",@barrier)
  end

end
