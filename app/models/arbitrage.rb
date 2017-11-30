class Arbitrage < ApplicationRecord
  belongs_to :trio
  belongs_to :first_order_book, class_name: 'OrderBook'
  belongs_to :second_order_book, class_name: 'OrderBook'
  belongs_to :third_order_book, class_name: 'OrderBook'
end
