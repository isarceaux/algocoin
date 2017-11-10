class CreateTrios < ActiveRecord::Migration[5.1]
  def change
    create_table :trios do |t|
      t.string :currency1_code
      t.string :currency2_code
      t.string :currency3_code
      t.timestamps
    end
  end
end
