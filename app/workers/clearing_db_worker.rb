class ClearingDbWorker

  include Sidekiq::Worker
  
  def initialize
  end

  def perform(id)
    Arbitrage.find(id).destroy
  end
end