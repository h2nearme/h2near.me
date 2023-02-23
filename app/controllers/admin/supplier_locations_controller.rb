class Admin::SupplierLocationsController < Admin::BaseController
  def index
    @supplier_locations = SupplierLocation.all
  end
end



