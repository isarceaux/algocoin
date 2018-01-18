class CreateTrades < ActiveRecord::Migration[5.1]
  def change
    create_table :trades do |t|
      t.integer :poloniex_global_trade_id
      t.integer :poloniex_trade_id
      t.float :rate
      t.float :amount
      t.float :total
      t.float :fee
      t.integer :poloniex_order_number
      t.string :type
      t.string :category
      t.references :pair, index:true
      t.time :trade_time, index:true
      t.references :arbitrage
      t.boolean :passed_trade
      t.timestamps
    end
  end
end
