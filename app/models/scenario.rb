class Scenario < ApplicationRecord
  include Hashid::Rails

  before_save :run_calculations

  belongs_to :offtaker_location
  belongs_to :supplier_location
  
  validates :distance, presence: true

  def present
    ScenarioPresenter.new(self)
  end

  def run_calculations
    attributes = CostCalculationService.new(self).call
    self.assign_attributes(attributes)
  end

  def compare_cheapest_h2(value)
    if value == self.costs_road
      return 'road'
    elsif value == self.costs_pipeline
      return 'pipeline'
    elsif value == self.costs_import
      return 'import'
    end
  end
end
