class GettingOrderBookWorker

  include Sidekiq::Worker

  URL_FIX_ZERO = 'https://poloniex.com/public?command='

  def intialize
  end

  def perform
    getting_order_books(10)
  end

  def getting_order_books(depth)

    pairs = Pair.all
    order_book_json = {}

    pairs.each do |pair|
      order_book_json = HTTParty.get(url_build_order_book(pair.first_currency.code,pair.second_currency.code,depth)).parsed_response
      
      new_order_book          = OrderBook.new
      new_order_book.pair     = pair
      new_order_book.depth    = depth
      new_order_book.ask_hash = order_book_json["asks"]
      new_order_book.bid_hash = order_book_json["bids"]
      new_order_book.save

    end
    
  end

  def url_build_order_book( pair1 , pair2 , depth )
    return url_build('returnOrderBook&currencyPair=') + pair1 + '_' + pair2 + '&depth=' + depth.to_s
  end

  def url_build( command )
    return URL_FIX_ZERO + command
  end

end