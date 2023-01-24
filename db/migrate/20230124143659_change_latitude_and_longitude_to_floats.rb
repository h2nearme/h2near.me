class ChangeLatitudeAndLongitudeToFloats < ActiveRecord::Migration[7.0]
  def change
    change_column :supplier_locations, :latitude, 'float USING CAST(latitude AS float)'
    change_column :supplier_locations, :longitude, 'float USING CAST(longitude AS float)'

    change_column :offtaker_locations, :latitude, 'float USING CAST(latitude AS float)'
    change_column :offtaker_locations, :longitude, 'float USING CAST(longitude AS float)'
  end
end
