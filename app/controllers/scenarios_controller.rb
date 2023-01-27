class ScenariosController < ApplicationController
  def create
    is_new_record = false
    @scenario = Scenario.find_by(
      supplier_location_id: params[:scenario][:supplier_location_id],
      offtaker_location_id: params[:scenario][:offtaker_location_id]
    )
    
    unless @scenario
      is_new_record = true
      @scenario = Scenario.new(scenario_params)
      @scenario.save!
    end
    
    respond_to do |format|
      format.json {
          render json: {
              scenario: @scenario,
              scenario_html: scenario_response(is_new_record), 
          }
      }
    end
  end

  def show
    @scenario = Scenario.find(params[:id])
  end

  private

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