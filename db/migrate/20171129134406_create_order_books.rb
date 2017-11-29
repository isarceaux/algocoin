class CreateOrderBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :order_books do |t|
      t.references :pair, index:true
      t.integer :depth
      t.hash :bid_hash
      t.hash :ask_hash
      t.timestamps, index:true
    end
    #Migration not yet run
  end
end
