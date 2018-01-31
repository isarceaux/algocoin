class SidekiqLaunch

  def initialize(number_of_times, ratio_value)
    
    # number_of_times.times do
    #   CalculatingArbitrageWorker.perform_async(ratio_value)
    # end

    number_of_times.times do
      MakingArbitrageWorker.perform_async(ratio_value)
    end

    ## To clear data uncomment these lines
    # OrderBook.pluck('id').each do |id|
    #   ClearingDbWorker.perform_async(id)
    # end
  end

  def perform

  end

end