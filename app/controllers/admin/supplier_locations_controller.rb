class Admin::SupplierLocationsController < Admin::BaseController
  def index
    @dashboard = true
    if params[:supply_type]
      supply_filter_types = params.require(:supply_type).permit(['Standard', 'ITMs', 'Pure', 'High pure', 'Ultrapure'].map {|item| item.to_sym}).to_hash.map {|key, value| key }
    else
      supply_filter_types = []
    end
    if params[:request_type]
      @request_filter_types = params.require(:request_type).permit(['Standard', 'ITMs', 'Pure', 'High pure', 'Ultrapure'].map {|item| item.to_sym}).to_hash.map {|key, value| key }
    else
      @request_filter_types = []
    end
    if params[:q]
      @supplier_locations = SupplierLocation.where("name ILIKE ?", "%#{params[:q]}%").order('updated_at DESC')

    else
      @supplier_locations = SupplierLocation.all.order('updated_at DESC')
    end
    if supply_filter_types.any?
      @supplier_locations = @supplier_locations.joins(:supply_types).where(supply_types: { name: supply_filter_types })
    end
    @supplier_locations = @supplier_locations.paginate(page: params[:page], per_page: 5)
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



