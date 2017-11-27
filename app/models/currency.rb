class Currency < ApplicationRecord

  has_many :first_currency_pairs, foreign_key: "first_currency_id", class_name: "Pair"
  has_many :second_currency_pairs, foreign_key: "second_currency_id", class_name: "Pair"

  has_many :first_currency_trios, foreign_key: "first_currency_id", class_name: "Trio"
  has_many :second_currency_trios, foreign_key: "second_currency_id", class_name: "Trio"
  has_many :third_currency_trios, foreign_key: "third_currency_id", class_name: "Trio"

end
