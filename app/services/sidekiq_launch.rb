class SidekiqLaunch

  def initialize
    GettingOrderBookWorker.perform_async(10)
  end

  def perform

  end

end