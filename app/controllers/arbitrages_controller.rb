class ArbitragesController < ApplicationController

  before_action :authenticate_user!

  def index
    @order_book_count = OrderBook.all.count
    # @barrier = 1.0076 #Limite de rentabilité
    @barrier = 1.01
    @arbitrage_selection = Arbitrage.where("raw_ratio > ?",@barrier)
  end

  def show
    @arbitrage = Arbitrage.find(params[:id])
  end

end
