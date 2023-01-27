class ScenariosController < ApplicationController
  def create
    @scenario = Scenario.find_by(
      supplier_location_id: params[:scenario][:supplier_location_id],
      offtaker_location_id: params[:scenario][:offtaker_location_id]
    )
    
    unless @scenario
      @scenario = Scenario.new(scenario_params)
      @scenario.save
    end
    
    respond_to do |format|
      format.json {
          render json: {
              scenario: @scenario,
              calculation: @scenario.run_calculations
          }
      }
    end
  end

  private

  def scenario_params
    params.require(:scenario).permit(:distance, :supplier_location_id, :offtaker_location_id)
  end
end