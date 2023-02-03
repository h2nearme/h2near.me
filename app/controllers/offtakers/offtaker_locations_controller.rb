class Offtakers::OfftakerLocationsController < Offtakers::BaseController
  before_action :set_offtaker_location, only: [:show, :edit, :update, :destroy]

  def dashboard
    if params[:q]
      @offtaker_locations = current_offtaker.offtaker_locations.where("name ILIKE ?", "%#{params[:q]}%").order('updated_at DESC').paginate(page: params[:page], per_page: 10)
    else
      @offtaker_locations = current_offtaker.offtaker_locations.order('updated_at DESC').paginate(page: params[:page], per_page: 10)
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
    offtaker_pressure_hydrogen = @offtaker_location.req_pressure_hydrogen.to_f.zero? ? 0.0 : ['both', @offtaker_location.req_pressure_hydrogen.to_f.to_s]
    offtaker_pressure_oxygen = @offtaker_location.req_pressure_oxygen.to_f.zero? ? 0.0 : ['both', @offtaker_location.req_pressure_oxygen.to_f.to_s]
    locations = SupplierLocation.near(
      @offtaker_location.coordinates, 
      500, 
      units: :km
    ).where(
      'min_hydrogen_vol <= ? AND max_hydrogen_vol >= ? AND min_oxygen_vol <= ? AND max_oxygen_vol >= ?',
      (@offtaker_location.req_hydrogen_vol || 0),
      (@offtaker_location.req_hydrogen_vol || 0),
      (@offtaker_location.req_oxygen_vol || 0),
      (@offtaker_location.req_oxygen_vol || 0),
    ).where(
      pressure_type_hydrogen: offtaker_pressure_hydrogen,
      pressure_type_oxygen: offtaker_pressure_oxygen,
      verified: true,
      available: true,
      hydrogen_purity: (@offtaker_location.required_purity_hydrogen || [nil, 'pure', 'high pure', 'ultrapure']),
      oxygen_purity: (@offtaker_location.required_purity_oxygen || [nil, 'pure', 'high pure', 'ultrapure']),
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
      :req_hydrogen_vol, 
      :req_oxygen_vol, 
      :req_pressure_hydrogen, 
      :req_pressure_oxygen, 
      :own_transport
    )
  end
end