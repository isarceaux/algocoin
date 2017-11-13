class Pair < ApplicationRecord
  belongs_to :first_currency, class_name: 'Currency'
  belongs_to :second_currency, class_name: 'Currency'
end
