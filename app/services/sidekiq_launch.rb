class SidekiqLaunch

  def initialize
    # CalculatingArbitrageWorker.perform_async
    Arbitrage.pluck('id').each do |id|
      ClearingDbWorker.perform_async(id)
    end
  end

  def perform

  end

end