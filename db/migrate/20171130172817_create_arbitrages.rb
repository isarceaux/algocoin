class CreateArbitrages < ActiveRecord::Migration[5.1]
  def change
    create_table :arbitrages do |t|
      t.references :trio, index:true
      t.references :first_order_book
      t.references :second_order_book
      t.references :third_order_book
      t.float :raw_ratio
      t.timestamps
    end
  end
end
