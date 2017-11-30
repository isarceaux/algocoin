class OrderBook < ApplicationRecord
  serialize :bid_hash
  serialize :ask_hash

  belongs_to :pair

  has_many :first_order_book_arbitrages, foreign_key: "first_order_book_id", class_name: "Arbitrage"
  has_many :second_order_book_arbitrages, foreign_key: "second_order_book_id", class_name: "Arbitrage"
  has_many :third_order_book_arbitrages, foreign_key: "third_order_book_id", class_name: "Arbitrage"

end
