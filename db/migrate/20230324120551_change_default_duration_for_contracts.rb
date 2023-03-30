class ChangeDefaultDurationForContracts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :offtaker_locations, :investment_period_years, 1 
    change_column_default :offtaker_locations, :contract_period_years, 1 
  end
end
