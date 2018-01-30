class ChangeColumnTypeName < ActiveRecord::Migration[5.1]
  def change
    rename_column :trades, :type, :buy_or_sell
  end
end
