class CreateTrios < ActiveRecord::Migration[5.1]
  def change
    create_table :trios do |t|
      t.references :first_currency, index:true
      t.references :second_currency, index:true
      t.references :third_currency, index:true
      t.timestamps
    end
  end
end
