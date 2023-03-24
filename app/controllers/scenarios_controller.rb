class ScenariosController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :set_scenario, only: [:show, :destroy, :mark_favourite, :calculate_again]

  def create
    session.delete(:first_visit)
    is_new_record = false
    @scenario = Scenario.find_by(
      supplier_location_id: params[:scenario][:supplier_location_id],
      offtaker_location_id: params[:scenario][:offtaker_location_id]
    )
    
    unless @scenario
      is_new_record = true
      @scenario = Scenario.new(scenario_params)
    end
    @scenario.distance = params["scenario"]["distance"]
    @scenario.save!
    
    respond_to do |format|
      format.json {
          render json: {
              scenario: @scenario,
              scenario_url: scenario_url(@scenario),
              scenario_html: scenario_response(is_new_record), 
          }
      }
    end
  end

  def show
    if @scenario.costs_pipeline.nil? && 
       @scenario.costs_road.nil?
        @scenario.run_calculations
    end
    @cheapest = [@scenario.costs_road, @scenario.costs_pipeline, @scenario.costs_import].min
  end

  def destroy
    @scenario.destroy
    if current_offtaker
      redirect_to offtakers_path
    elsif current_supplier
      redirect_to suppliers_path
    end
  end

  def mark_favourite
    @scenario.favourite = !@scenario.favourite
    @scenario.save
    respond_to do |format|
      format.js
      format.json {
        render json: {
            scenario: @scenario,
        }
    }
    end
  end

  def calculate_again
    @scenario.run_calculations
    @scenario.save
    redirect_to scenario_path(@scenario)
  end

  private

  def set_scenario
    @scenario = Scenario.find(params[:id])
  end

  def scenario_response(is_new_record)
    if is_new_record
      render_to_string(
        partial: "scenarios/scenario", 
        formats: [:html], 
        locals: { 
          scenario: @scenario 
          }
        )
    else
      ""
    end
  end

  def scenario_params
    params.require(:scenario).permit(:distance, :supplier_location_id, :offtaker_location_id)
  end
end