class ListsController < ApplicationController

  before_action :authenticate_user!

  def of_currencies
    @currencies = Currency.all
  end

  def of_pairs
    @pairs = Pair.all
    @currencies = Currency.all
  end

  def of_trios
    @trios = Trio.all
    @currencies = Currency.all
  end

end
