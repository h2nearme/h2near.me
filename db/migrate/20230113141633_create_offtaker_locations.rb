class CreateOfftakerLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :offtaker_locations do |t|
      t.references :offtaker, null: false, foreign_key: true
      t.string :name
      t.string :longitude
      t.string :latitude
      t.string :postal_code
      t.string :house_nr
      t.boolean :own_transport
      t.float :req_hydrogen_vol
      t.float :req_oxygen_vol
      t.float :req_pressure_hydrogen
      t.float :req_pressure_oxygen

      t.timestamps
    end
  end
end
