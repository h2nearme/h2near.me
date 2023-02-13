class AddCompressionCosts < ActiveRecord::Migration[7.0]
  def change
    #offtaker_locations
    rename_column :offtaker_locations, :req_hydrogen_vol, :required_hydrogen_volume 
    rename_column :offtaker_locations, :req_oxygen_vol, :required_oxygen_volume 
    rename_column :offtaker_locations, :req_pressure_hydrogen, :required_hydrogen_pressure
    remove_column :offtaker_locations, :req_pressure_oxygen
    rename_column :offtaker_locations, :required_purity_hydrogen, :required_hydrogen_purity
    remove_column :offtaker_locations, :required_purity_oxygen
    add_column :offtaker_locations, :interest_oxygen, :boolean, default: false
    add_column :offtaker_locations, :investment_period_years, :integer, default: false
    add_column :offtaker_locations, :contract_period_years, :integer, default: false

    #scenarios
    rename_column :scenarios, :costs_pipeline_h2, :costs_pipeline
    rename_column :scenarios, :costs_road_h2, :costs_road
    rename_column :scenarios, :costs_import_h2, :costs_import
    remove_column :scenarios, :distance_lorry
    remove_column :scenarios, :costs_pipeline_o2
    remove_column :scenarios, :costs_road_o2
    remove_column :scenarios, :costs_import_o2  
    rename_column :scenarios, :distance_pipeline, :distance
    change_column :scenarios, :costs_pipeline, :integer
    change_column :scenarios, :costs_road, :integer
    change_column :scenarios, :costs_import, :integer

    #supplier_locations
    remove_column :supplier_locations, :supply_type
    remove_column :supplier_locations, :min_hydrogen_vol
    remove_column :supplier_locations, :max_hydrogen_vol
    remove_column :supplier_locations, :min_oxygen_vol
    remove_column :supplier_locations, :max_oxygen_vol
    remove_column :supplier_locations, :pressure_type_hydrogen
    remove_column :supplier_locations, :pressure_type_oxygen
    remove_column :supplier_locations, :transport_costs
    remove_column :supplier_locations, :hydrogen_purity
    remove_column :supplier_locations, :oxygen_purity    

    #supply_type
    create_table :supply_types do |t|
      t.references :supplier_location, null: false, foreign_key: true
      t.string :name
      t.float :minimum_hydrogen_volume
      t.float :maximum_hydrogen_volume
      t.float :pressure_type_hydrogen
      t.integer :compression_costs
      t.integer :transport_costs
    end

  end
end
