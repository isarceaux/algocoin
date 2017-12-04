class AddWorstRatioToArbitrages < ActiveRecord::Migration[5.1]
  def change
    add_column :arbitrages, :worst_ratio, :float
    add_index :arbitrages, :worst_ratio
  end
end
