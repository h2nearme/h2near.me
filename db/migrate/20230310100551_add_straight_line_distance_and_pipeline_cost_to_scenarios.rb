class AddStraightLineDistanceAndPipelineCostToScenarios < ActiveRecord::Migration[7.0]
  def change
    add_column :scenarios, :distance_straight_line, :float
    add_column :scenarios, :costs_pipeline_straight_line, :integer
  end
end
