class CreateOrderBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :order_books do |t|
      t.references :pair, index:true
      t.integer :depth
      t.string :bid_hash
      t.string :ask_hash
      t.timestamps
    end
  end
end
