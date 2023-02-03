class Scenario < ApplicationRecord
  include Hashid::Rails

  before_save :run_calculations

  belongs_to :offtaker_location
  belongs_to :supplier_location

  def run_calculations
    attributes = CostCalculationService.new(self).call
    self.assign_attributes(attributes)
  end

  def compare_cheapest_h2(value)
    if value == self.costs_road_h2
      return 'road'
    elsif value == self.costs_pipeline_h2
      return 'pipeline'
    elsif value == self.costs_import_h2
      return 'import'
    end
  end
end
