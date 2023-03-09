class Suppliers::SupplierLocationsController < Suppliers::BaseController
  before_action :set_supplier_location, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_supplier!, if: :current_admin, only: [:show]

  def dashboard
    @dashboard = true
    if params[:q]
      @supplier_locations = current_supplier.supplier_locations.where("name ILIKE ?", "%#{params[:q]}%").order('updated_at DESC').paginate(page: params[:page], per_page: 5)
    else
      @supplier_locations = current_supplier.supplier_locations.order('updated_at DESC').paginate(page: params[:page], per_page: 5)
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
    @supplier_location.supply_types.build
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
    @supplier_location.supply_types.build
  end

  def update
    if @supplier_location.update!(supplier_location_params)
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
      :pickup_available,
      :has_drtfc,
      :purification_onsite,
      supply_types_attributes: [
        :id,
        :verified,
        :available,
        :pickup_available,
        :has_drtfc,
        :purification_onsite,
        :name,
        :minimum_hydrogen_volume,
        :maximum_hydrogen_volume,
        :pressure_type_hydrogen,
        :compression_costs,
        :transport_costs,
        :purity_proof,
        :supply_proof
      ]
    )
  end
end



