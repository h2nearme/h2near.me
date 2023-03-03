class AddValueBreakdownToScenarios < ActiveRecord::Migration[7.0]
  def change
    add_column :scenarios, :value_breakdown, :json
  end
end
