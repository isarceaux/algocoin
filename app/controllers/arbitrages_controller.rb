class ArbitragesController < ApplicationController

  def index
    @order_book_count = OrderBook.all.count
    @barrier = 1
    @arbitrage_selection = Arbitrage.where("raw_ratio > ?",@barrier)
  end

  def show
    @arbitrage = Arbitrage.find(params[:id])
  end

end
