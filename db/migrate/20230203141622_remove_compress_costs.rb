class RemoveCompressCosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :supplier_locations, :compression_costs
  end
end
