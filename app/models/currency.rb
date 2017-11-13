class Currency < ApplicationRecord
  has_many :first_currency_pairs, foreign_key: "first_currency_id", class_name: "Pair"
  has_many :second_currency_pairs, foreign_key: "second_currency_id", class_name: "Pair"

  # has_many :second_currencies, through: :pairs#, foreign_key:"first_currency_id"
  # has_many :first_currencies, through: :pairs#, foreign_key:"second_currency_id"
end
