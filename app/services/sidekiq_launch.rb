class SidekiqLaunch

  def initialize
    GettingOrderBookWorker.new.perform
  end

  def perform

  end

end