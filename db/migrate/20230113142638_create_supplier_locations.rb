class CreateSupplierLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :supplier_locations do |t|
      t.references :supplier, null: false, foreign_key: true
      t.string :name
      t.string :longitude
      t.string :latitude
      t.string :postal_code
      t.string :house_nr
      t.string :supply_type
      t.float :min_hydrogen_vol
      t.float :max_hydrogen_vol
      t.float :min_oxygen_vol
      t.float :max_oxygen_vol
      t.boolean :pickup_available
      t.string :pressure_type_hydrogen
      t.string :pressure_type_oxygen
      t.string :energy_type
      t.boolean :verified
      t.boolean :available
      t.integer :transport_costs
      t.integer :compression_costs

      t.timestamps
    end
  end
end
