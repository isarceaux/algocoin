class CreatePairs < ActiveRecord::Migration[5.1]
  def change
    create_table :pairs do |t|
      t.references :first_currency, index:true
      t.references :second_currency, index:true
      t.timestamps
    end
  end
end
