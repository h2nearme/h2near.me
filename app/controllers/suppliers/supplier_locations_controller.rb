class SupplierLocations < ApplicationController
  before_action :set_supplier_location, only: [:show, :edit, :update, :destroy]

  def dashboard
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_supplier_location
  end

  def supplier_location_params
    params.require(:supplier_location).permit(:name)
  end
end