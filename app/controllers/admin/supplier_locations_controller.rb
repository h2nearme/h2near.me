class Admin::SupplierLocationsController < Admin::BaseController
  def index
    @dashboard = true
    if params[:q]
      @supplier_locations = SupplierLocation.where("name ILIKE ?", "%#{params[:q]}%").order('updated_at DESC').paginate(page: params[:page], per_page: 5)

    else
      @supplier_locations = SupplierLocation.all.order('updated_at DESC').paginate(page: params[:page], per_page: 5)
    end
    set_metrics_data
    respond_to do |format|
      format.html
      format.json {
          render json: {
              locations: render_to_string(partial: "admin/supplier_locations/locations", formats: [:html]), 
          }
      }
    end
  end

  def verify
    @supplier_location = SupplierLocation.find(params[:id])
    @supplier_location.verified = !@supplier_location.verified
    @supplier_location.save
    respond_to do |format|
      format.js
      format.json {
        render json: {
            supplier_location: @supplier_location,
        }
    }
    end
  end

  private

  def set_metrics_data
    @top_five_offtaker_location_by_volume_required = OfftakerLocation.all.order(required_hydrogen_volume: :desc).first(5)
    @top_five_supplier_location_by_scenarios = SupplierLocation.joins(:scenarios).group(:name).count.sort.first(5)
  end
end



