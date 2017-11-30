class OrderBook < ApplicationRecord
  serialize :bid_hash
  serialize :ask_hash

  belongs_to :pair

end
