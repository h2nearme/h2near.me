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

  def self.set_history_for_chart_month_creation(start_date)
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    past_year_scenarios = Scenario.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date))
    grouped_by_month = past_year_scenarios.group_by {|scenario| scenario.created_at.strftime("%b") }
    formatted_months = grouped_by_month.map {|month, scenarios| [month, (scenarios.inject(0) do |sum, scenario|
      sum += 1
    end)]}
    padded_months = months.map do |month| 
      month_with_data = formatted_months.find {|month_name, sum| month == month_name }
      [month, (month_with_data ? month_with_data[1].round(2) : 0)]
    end
    return padded_months
  end

  def self.set_history_for_chart_month_cost_comparison(start_date)
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    past_year_scenarios = Scenario.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date))
    grouped_by_month = past_year_scenarios.group_by {|scenario| scenario.created_at.strftime("%b") }

    formatted_months_road = grouped_by_month.map {|month, scenarios| [month, (scenarios.inject(0) do |sum, scenario|
      sum += (scenario.costs_road > scenario.costs_pipeline ? 0 : 1)
    end)]}

    formatted_months_pipeline = grouped_by_month.map {|month, scenarios| [month, (scenarios.inject(0) do |sum, scenario|
      sum += (scenario.costs_road > scenario.costs_pipeline ? 1 : 0)
    end)]}


    padded_months_road = months.map do |month| 
      month_with_data = formatted_months_road.find {|month_name, sum| month == month_name }
      [month, (month_with_data ? month_with_data[1].round(2) : 0)]
    end

    padded_months_pipeline = months.map do |month| 
      month_with_data = formatted_months_pipeline.find {|month_name, sum| month == month_name }
      [month, (month_with_data ? month_with_data[1].round(2) : 0)]
    end
    return [
      {
        name: 'Costs road cheapest',
        data: padded_months_road
      },
      {
        name: 'Costs pipeline cheapest',
        data: padded_months_pipeline
      }
    ]
  end

  def self.set_history_for_chart_month_average_distance(start_date)
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    past_year_scenarios = Scenario.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date))
    grouped_by_month = past_year_scenarios.group_by {|scenario| scenario.created_at.strftime("%b") }
    formatted_months = grouped_by_month.map {|month, scenarios| [month, (scenarios.inject(0) do |sum, scenario|
      sum += (scenario.distance || 0)
    end)]}
    padded_months = months.map do |month| 
      month_with_data = formatted_months.find {|month_name, sum| month == month_name }
      [month, (month_with_data ? month_with_data[1].round(2) / past_year_scenarios.count : 0)]
    end
    return padded_months
  end

  def self.set_history_for_chart_month_average_pipeline_cost(start_date)
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    past_year_scenarios = Scenario.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date))
    grouped_by_month = past_year_scenarios.group_by {|scenario| scenario.created_at.strftime("%b") }
    formatted_months = grouped_by_month.map {|month, scenarios| [month, (scenarios.inject(0) do |sum, scenario|
      sum += (scenario.costs_pipeline || 0)
    end)]}
    padded_months = months.map do |month| 
      month_with_data = formatted_months.find {|month_name, sum| month == month_name }
      [month, (month_with_data ? month_with_data[1].round(2) / past_year_scenarios.count : 0)]
    end
    return padded_months
  end

  def self.set_history_for_chart_month_average_road_cost(start_date)
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    past_year_scenarios = Scenario.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date))
    grouped_by_month = past_year_scenarios.group_by {|scenario| scenario.created_at.strftime("%b") }
    formatted_months = grouped_by_month.map {|month, scenarios| [month, (scenarios.inject(0) do |sum, scenario|
      sum += (scenario.costs_road || 0)
    end)]}
    padded_months = months.map do |month| 
      month_with_data = formatted_months.find {|month_name, sum| month == month_name }
      [month, (month_with_data ? month_with_data[1].round(2) / past_year_scenarios.count : 0)]
    end
    return padded_months
  end
end
