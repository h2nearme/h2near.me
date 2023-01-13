class CreateScenarios < ActiveRecord::Migration[7.0]
  def change
    create_table :scenarios do |t|
      t.references :offtaker_location, null: false, foreign_key: true
      t.references :supplier_location, null: false, foreign_key: true
      t.integer :costs_pipeline
      t.integer :costs_road
      t.integer :costs_import
      t.float :distance

      t.timestamps
    end
  end
end
