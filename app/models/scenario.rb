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

  def self.compose_chart_data_weekly(start_date)
    past_week_dates = (start_date..(start_date + 6.days).to_date).map{ |date| date }
    past_week_scenarios = Scenario.where(created_at: (start_date..(start_date + 6.days).to_date))
    formatted_dates = past_week_dates.map do |date|
      scenarios = past_week_scenarios.select {|scenario| scenario.created_at.to_date == date }
      [date.strftime("%a"), (scenarios.inject(0) do |sum, scenario|
        sum += yield(scenario)
      end)]
    end
    return formatted_dates
  end

  def self.compose_chart_data_monthly(start_date)
    week_numbers_this_month = (start_date.beginning_of_month.to_date..start_date.end_of_month.to_date).uniq {|date| date.strftime("%U")}.map {|date| date.strftime("%U").to_i}
    past_month_scenarios = Scenario.where(created_at: (start_date.beginning_of_month.to_date..start_date.end_of_month.to_date))
    grouped_by_weeknumber = past_month_scenarios.group_by {|scenario| scenario.created_at.strftime("%U").to_i }

    formatted_weeks = grouped_by_weeknumber.map {|week_number, scenarios| [week_number, (scenarios.inject(0) do |sum, scenario|
      sum += yield(scenario)
    end)]}
    padded_weeks = week_numbers_this_month.map do |number| 
      week_with_data = formatted_weeks.find {|week_number, sum| number == week_number }
      ["Week #{number} | #{start_date.strftime("%b")}", (week_with_data ? week_with_data[1].round(2) : 0)]
    end
    return padded_weeks
  end

  def self.compose_chart_data_yearly(start_date)
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    past_year_scenarios = Scenario.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date))
    grouped_by_month = past_year_scenarios.group_by {|scenario| scenario.created_at.strftime("%b") }
    formatted_months = grouped_by_month.map {|month, scenarios| [month, (scenarios.inject(0) do |sum, scenario|
      sum += yield(scenario)
    end)]}
    padded_months = months.map do |month| 
      month_with_data = formatted_months.find {|month_name, sum| month == month_name }
      [month, (month_with_data ? month_with_data[1].round(2) : 0)]
    end
    return padded_months
  end

  def self.set_history_for_chart_creation(start_date, variant)
    case variant
    when 'weekly'
      compose_chart_data_weekly(start_date) do |scenario|
        1
      end
    when 'monthly'
      compose_chart_data_monthly(start_date) do |scenario|
        1
      end
    when 'yearly'
      compose_chart_data_yearly(start_date) do |scenario|
        1
      end
    end
  end
  
  def self.set_history_for_chart_average_road_cost(start_date, variant)
    case variant
    when 'weekly'
      compose_chart_data_weekly(start_date) do |scenario|
        (scenario.costs_road || 0)
      end
    when 'monthly'
      compose_chart_data_monthly(start_date) do |scenario|
        (scenario.costs_road || 0)
      end
    when 'yearly'
      compose_chart_data_yearly(start_date) do |scenario|
        (scenario.costs_road || 0)
      end
    end
  end
  
  def self.set_history_for_chart_average_distance(start_date, variant)
    case variant
    when 'weekly'
      compose_chart_data_weekly(start_date) do |scenario|
        (scenario.distance || 0)
      end
    when 'monthly'
      compose_chart_data_monthly(start_date) do |scenario|
        (scenario.distance || 0)
      end
    when 'yearly'
      compose_chart_data_yearly(start_date) do |scenario|
        (scenario.distance || 0)
      end
    end
  end

  def self.set_history_for_chart_average_pipeline_cost(start_date, variant)
    case variant
    when 'weekly'
      compose_chart_data_weekly(start_date) do |scenario|
        (scenario.costs_pipeline || 0)
      end
    when 'monthly'
      compose_chart_data_monthly(start_date) do |scenario|
        (scenario.costs_pipeline || 0)
      end
    when 'yearly'
      compose_chart_data_yearly(start_date) do |scenario|
        (scenario.costs_pipeline || 0)
      end
    end
  end

end
