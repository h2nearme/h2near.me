class Suppliers::SupplierLocationsController < Suppliers::BaseController
  before_action :set_supplier_location, only: [:show, :edit, :update, :destroy]

  def dashboard
    if params[:q]
      @supplier_locations = current_supplier.supplier_locations.where("name ILIKE ?", "%#{params[:q]}%").order('updated_at DESC').paginate(page: params[:page], per_page: 10)
    else
      @supplier_locations = current_supplier.supplier_locations.order('updated_at DESC').paginate(page: params[:page], per_page: 10)
    end
    @scenarios = current_supplier.scenarios
    respond_to do |format|
      format.html
      format.json {
          render json: {
              locations: render_to_string(partial: "suppliers/supplier_locations/locations", formats: [:html]), 
          }
      }
    end
  end

  def show
    @offtaker_locations = OfftakerLocation.near(@supplier_location.coordinates, 200, units: :km)
  end

  def new
    @supplier_location = SupplierLocation.new
  end

  def create
    @supplier_location = SupplierLocation.new(supplier_location_params)
    @supplier_location.verified = true
    @supplier_location.supplier = current_supplier
    if @supplier_location.save!
      redirect_to suppliers_supplier_location_path(@supplier_location)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @supplier_location.update(supplier_location_params)
      redirect_to suppliers_supplier_location_path(@supplier_location)
    else
      render :edit
    end
  end

  def destroy
    if @supplier_location.destroy
      redirect_to suppliers_path
    else
      redirect_to suppliers_path
    end
  end

  private

  def set_supplier_location
    @supplier_location = SupplierLocation.find(params[:id])
  end

  def supplier_location_params
    params.require(:supplier_location).permit(
      :name, 
      :longitude, 
      :latitude, 
      :postal_code, 
      :house_nr, 
      :verified,
      :available,
      :supply_type,
      :pickup_available,
      :has_drtfc,
      :purification_onsite,
      :min_hydrogen_vol,
      :max_hydrogen_vol,
      :pressure_type_hydrogen,
      :hydrogen_purity,
      :min_oxygen_vol,
      :max_oxygen_vol,
      :pressure_type_oxygen,
      :oxygen_purity,
      :transport_costs,
      :compression_costs
    )
  end
end



