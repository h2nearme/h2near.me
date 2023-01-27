class ChangeScenarioCosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :scenarios, :costs_pipeline
    remove_column :scenarios, :costs_road
    remove_column :scenarios, :costs_import
    remove_column :scenarios, :distance
    add_column :scenarios, :costs_pipeline_h2, :float
    add_column :scenarios, :costs_road_h2, :float
    add_column :scenarios, :costs_import_h2, :float
    add_column :scenarios, :distance_lorry, :float
    add_column :scenarios, :costs_pipeline_o2, :float
    add_column :scenarios, :costs_road_o2, :float
    add_column :scenarios, :costs_import_o2, :float
    add_column :scenarios, :distance_pipeline, :float
    remove_column :supplier_locations, :has_drftc
    add_column :supplier_locations, :has_drtfc, :float
  end
end
