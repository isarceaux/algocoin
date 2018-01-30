class Trade < ApplicationRecord
  belongs_to :pair
  belongs_to :arbitrage
end
