class Offtakers::OfftakerLocationsController < Offtakers::BaseController
  before_action :set_offtaker_location, only: [:show, :edit, :update, :destroy]

  def dashboard
    if params[:q]
      @offtaker_locations = current_offtaker.offtaker_locations.where("name ILIKE ?", "%#{params[:q]}%").order('updated_at DESC').paginate(page: params[:page], per_page: 5)
    else
      @offtaker_locations = current_offtaker.offtaker_locations.order('updated_at DESC').paginate(page: params[:page], per_page: 5)
    end
    @scenarios = current_offtaker.scenarios.order(favourite: :desc).order('updated_at DESC')
    respond_to do |format|
      format.html
      format.json {
          render json: {
              locations: render_to_string(partial: "offtakers/offtaker_locations/locations", formats: [:html]), 
          }
      }
    end
  end

  def show
    @supplier_locations = nearest_supplier_locations
  end

  def new
    @offtaker_location = OfftakerLocation.new
  end

  def create
    @offtaker_location = OfftakerLocation.new(offtaker_location_params)
    @offtaker_location.offtaker = current_offtaker
    if @offtaker_location.save
      supplier_location = nearest_supplier_locations.first
      @scenario = Scenario.new(supplier_location: supplier_location, offtaker_location: @offtaker_location)
      if @scenario.save
        redirect_to scenario_path(@scenario)
      else
        redirect_to offtakers_offtaker_location_path(@offtaker_location)
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @offtaker_location.update(offtaker_location_params)
      redirect_to offtakers_offtaker_location_path(@offtaker_location)
    else
      render :edit
    end
  end

  def destroy
    if @offtaker_location.destroy
      redirect_to offtakers_path
    else
      redirect_to offtakers_path
    end
  end

  private

  def nearest_supplier_locations
    offtaker_pressure_hydrogen = @offtaker_location.required_hydrogen_pressure.to_f.zero? ? 0.0 : @offtaker_location.required_hydrogen_pressure.to_f.to_s
    locations = SupplierLocation.near(
      @offtaker_location.coordinates, 
      500, 
      units: :km
    ).joins(:supply_types).where(
      'supply_types.minimum_hydrogen_volume <= ? AND supply_types.maximum_hydrogen_volume >= ? AND supply_types.pressure_type_hydrogen = ? AND supply_types.name = ?',
      (@offtaker_location.required_hydrogen_volume || 0),
      (@offtaker_location.required_hydrogen_volume || 0),
      offtaker_pressure_hydrogen,
      @offtaker_location.required_hydrogen_purity
    ).where(
      verified: true,
      available: true,
    )
    if @offtaker_location.own_transport
      locations = locations.where(pickup_available: @offtaker_location.own_transport)
    end
    return locations
  end

  def set_offtaker_location
    @offtaker_location = OfftakerLocation.find(params[:id])
  end

  def offtaker_location_params
    params.require(:offtaker_location).permit(
      :name, 
      :longitude, 
      :latitude, 
      :postal_code, 
      :house_nr, 
      :required_hydrogen_volume, 
      :required_oxygen_volume, 
      :required_hydrogen_pressure, 
      :required_hydrogen_purity,
      :own_transport,
      :investment_period_years,
      :contract_period_years,
      :interest_oxygen
    )
  end
end