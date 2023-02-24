class Admin::SupplierLocationsController < Admin::BaseController
  def index
    if params[:q]
      @supplier_locations = SupplierLocation.where("name ILIKE ?", "%#{params[:q]}%").order('updated_at DESC').paginate(page: params[:page], per_page: 10)

    else
      @supplier_locations = SupplierLocation.all.order('updated_at DESC').paginate(page: params[:page], per_page: 10)
    end
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
end



