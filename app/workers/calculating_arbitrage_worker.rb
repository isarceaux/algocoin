class CalculatingArbitrageWorker

  include Sidekiq::Worker

  URL_FIX_ZERO = 'https://poloniex.com/public?command='

  def initialize
  end

  def perform

    trios = Trio.all
    depth = 10

    trios.each do |trio|
      
      first_order_book = getting_order_books(trio.first_currency, trio.second_currency, depth)
      second_order_book = getting_order_books(trio.second_currency, trio.third_currency, depth)
      third_order_book = getting_order_books(trio.first_currency, trio.third_currency, depth)
      ratio = (1 / first_order_book.ask_hash.last[0].to_f) * (1 / second_order_book.ask_hash.last[0].to_f) * third_order_book.bid_hash.first[0].to_f
      worst_ratio = (1 / first_order_book.ask_hash.first[0].to_f) * (1 / second_order_book.ask_hash.first[0].to_f) * third_order_book.bid_hash.last[0].to_f 
      if ratio > 1
        new_arbitrage                   = Arbitrage.new
        new_arbitrage.trio              = trio
        new_arbitrage.first_order_book  = first_order_book
        new_arbitrage.second_order_book = second_order_book
        new_arbitrage.third_order_book  = third_order_book
        new_arbitrage.raw_ratio         = ratio
        new_arbitrage.worst_ratio       = worst_ratio
        new_arbitrage.save
      else
        first_order_book.destroy
        second_order_book.destroy
        third_order_book.destroy
      end

    end
    
  end

  def getting_order_books(first_currency, second_currency, depth)
    
    order_book_json = HTTParty.get(url_build_order_book(first_currency.code, second_currency.code,depth)).parsed_response  
    new_order_book          = OrderBook.new
    new_order_book.pair     = Pair.where(first_currency:first_currency).where(second_currency:second_currency)[0]
    new_order_book.depth    = depth
    new_order_book.ask_hash = order_book_json["asks"]
    new_order_book.bid_hash = order_book_json["bids"]
    new_order_book.save

    return new_order_book

  end

  def url_build_order_book( pair1 , pair2 , depth )
    return url_build('returnOrderBook&currencyPair=') + pair1 + '_' + pair2 + '&depth=' + depth.to_s
  end

  def url_build( command )
    return URL_FIX_ZERO + command
  end

end