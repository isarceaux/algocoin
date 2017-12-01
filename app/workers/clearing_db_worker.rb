class ClearingDbWorker

  include Sidekiq::Worker
  
  def initialize
  end

  def perform(id)
    OrderBook.find(id).destroy
  end
end