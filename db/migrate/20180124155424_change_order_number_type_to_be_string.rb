class ChangeOrderNumberTypeToBeString < ActiveRecord::Migration[5.1]
  def change
    change_column :trades, :poloniex_order_number, :string
  end
end
