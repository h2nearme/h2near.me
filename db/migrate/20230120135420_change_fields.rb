class ChangeFields < ActiveRecord::Migration[7.0]
  def change
    add_column :supplier_locations, :has_drftc, :boolean
    add_column :supplier_locations, :hydrogen_purity, :string
    add_column :supplier_locations, :oxygen_purity, :string
    add_column :supplier_locations, :purification_onsite, :boolean
    remove_column :supplier_locations, :energy_type
    add_column :offtaker_locations, :required_purity_hydrogen, :string
    add_column :offtaker_locations, :required_purity_oxygen, :string
    add_column :offtaker_locations, :prefixed_id, :string
    add_column :supplier_locations, :prefixed_id, :string
  end
end
