class Admin::SupplierLocationsController < Admin::BaseController
  def index
    @supplier_locations = SupplierLocation.all.order('updated_at DESC').paginate(page: params[:page], per_page: 10)
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
end



