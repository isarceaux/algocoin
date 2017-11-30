class SidekiqLaunch

  def initialize
    CalculatingArbitrageWorker.perform_async
  end

  def perform

  end

end