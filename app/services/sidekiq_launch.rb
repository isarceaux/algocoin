class SidekiqLaunch

  def initialize
    
    10.times do
      CalculatingArbitrageWorker.perform_async
    end

    ## To clear data uncomment these lines
    # OrderBook.pluck('id').each do |id|
    #   ClearingDbWorker.perform_async(id)
    # end
  end

  def perform

  end

end