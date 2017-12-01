class SidekiqLaunch

  def initialize
    
    CalculatingArbitrageWorker.perform_async

    ## To clear data uncomment these lines
    # OrderBook.pluck('id').each do |id|
    #   ClearingDbWorker.perform_async(id)
    # end
  end

  def perform

  end

end