class Currency < ApplicationRecord
  has_many :first_currency_pairs, foreign_key: "first_currency_id", class_name: "Pair"
  has_many :second_currency_pairs, foreign_key: "second_currency_id", class_name: "Pair"

  def initialize(currency_json)
    cnew = Currency.new
    cnew.code = currency_json[0]
    cnew.name = currency_json[1]["name"]
    cnew.save
  end

  # has_many :second_currencies, through: :pairs#, foreign_key:"first_currency_id"
  # has_many :first_currencies, through: :pairs#, foreign_key:"second_currency_id"
end
