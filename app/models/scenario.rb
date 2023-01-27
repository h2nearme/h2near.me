class Scenario < ApplicationRecord
  belongs_to :offtaker_location
  belongs_to :supplier_location

  def run_calculations
    CostCalculationService.new(self).call
  end
end
