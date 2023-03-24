class Api::V1::ChartsController < ApplicationController
  before_action :authenticate_admin!
  
  # Offtaker location creation
  def offtaker_location_weekly
    render json: OfftakerLocation.set_history_for_chart_creation(Date.parse(params["marker_date"]), 'weekly')
  end

  def offtaker_location_monthly
    render json: OfftakerLocation.set_history_for_chart_creation(Date.parse(params["marker_date"]), 'monthly')
  end

  def offtaker_location_yearly
    render json: OfftakerLocation.set_history_for_chart_creation(Date.parse(params["marker_date"]), 'yearly')
  end
    
  # Offtaker location by volume requested
  def offtaker_location_volume_weekly
    render json: OfftakerLocation.set_history_for_chart_volume(Date.parse(params["marker_date"]), 'weekly')
  end

  def offtaker_location_volume_monthly
    render json: OfftakerLocation.set_history_for_chart_volume(Date.parse(params["marker_date"]), 'monthly')
  end

  def offtaker_location_volume_yearly
    render json: OfftakerLocation.set_history_for_chart_volume(Date.parse(params["marker_date"]), 'yearly')
  end

  # Offtaker location by interest in oxygen
  def offtaker_location_oxygen_interest_weekly
    render json: OfftakerLocation.set_history_for_chart_oxygen_interest(Date.parse(params["marker_date"]), 'weekly')
  end

  def offtaker_location_oxygen_interest_monthly
    render json: OfftakerLocation.set_history_for_chart_oxygen_interest(Date.parse(params["marker_date"]), 'monthly')
  end

  def offtaker_location_oxygen_interest_yearly
    render json: OfftakerLocation.set_history_for_chart_oxygen_interest(Date.parse(params["marker_date"]), 'yearly')
  end

  # Scenario creation
  def scenario_weekly
    render json: Scenario.set_history_for_chart_creation(Date.parse(params["marker_date"]), 'weekly')
  end

  def scenario_monthly
    render json: Scenario.set_history_for_chart_creation(Date.parse(params["marker_date"]), 'monthly')
  end

  def scenario_yearly
    render json: Scenario.set_history_for_chart_creation(Date.parse(params["marker_date"]), 'yearly')
  end

  # Average road costs
  def average_road_costs_weekly
    render json: Scenario.set_history_for_chart_average_road_cost(Date.parse(params["marker_date"]), 'weekly')
  end

  def average_road_costs_monthly
    render json: Scenario.set_history_for_chart_average_road_cost(Date.parse(params["marker_date"]), 'monthly')
  end

  def average_road_costs_yearly
    render json: Scenario.set_history_for_chart_average_road_cost(Date.parse(params["marker_date"]), 'yearly')
  end

  # Average distance
  def average_distance_weekly
    render json: Scenario.set_history_for_chart_average_distance(Date.parse(params["marker_date"]), 'weekly')
  end

  def average_distance_monthly
    render json: Scenario.set_history_for_chart_average_distance(Date.parse(params["marker_date"]), 'monthly')
  end

  def average_distance_yearly
    render json: Scenario.set_history_for_chart_average_distance(Date.parse(params["marker_date"]), 'yearly')
  end

  # Average road costs
  def average_pipeline_costs_weekly
    render json: Scenario.set_history_for_chart_average_pipeline_cost(Date.parse(params["marker_date"]), 'weekly')
  end

  def average_pipeline_costs_monthly
    render json: Scenario.set_history_for_chart_average_pipeline_cost(Date.parse(params["marker_date"]), 'monthly')
  end

  def average_pipeline_costs_yearly
    render json: Scenario.set_history_for_chart_average_pipeline_cost(Date.parse(params["marker_date"]), 'yearly')
  end

  # Offtaker creation
  def offtaker_weekly
    render json: Offtaker.set_history_for_chart_creation(Date.parse(params["marker_date"]), 'weekly')
  end

  def offtaker_monthly
    render json: Offtaker.set_history_for_chart_creation(Date.parse(params["marker_date"]), 'monthly')
  end

  def offtaker_yearly
    render json: Offtaker.set_history_for_chart_creation(Date.parse(params["marker_date"]), 'yearly')
  end

  # Offtaker number of scenarios created
  def offtaker_scenarios_created_weekly
    render json: Offtaker.set_history_for_chart_scenarios_per_offtaker(Date.parse(params["marker_date"]), 'weekly')
  end

  def offtaker_scenarios_created_monthly
    render json: Offtaker.set_history_for_chart_scenarios_per_offtaker(Date.parse(params["marker_date"]), 'monthly')
  end

  def offtaker_scenarios_created_yearly
    render json: Offtaker.set_history_for_chart_scenarios_per_offtaker(Date.parse(params["marker_date"]), 'yearly')
  end

end
