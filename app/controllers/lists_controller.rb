class ListsController < ApplicationController

  def of_currencies
    @currencies = Currency.all
  end

  def of_pairs
    @pairs = Duo.all
    @currencies = Currency.all
  end

  def of_trios
    @trios = Trio.all
    @currencies = Currency.all
  end

end
