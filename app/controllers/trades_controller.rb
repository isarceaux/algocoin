class TradesController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @trades = Trade.all
  end
end
