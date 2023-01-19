class Suppliers::SupplierLocationsController < ApplicationController
  before_action :set_supplier_location, only: [:show, :edit, :update, :destroy]

  def dashboard
    @supplier_location = current_supplier.supplier_locations
  end

  def show
  end

  def new
    @supplier_location = SupplierLocation.new
  end

  def create
    @supplier_location = SupplierLocation.new(supplier_location_params)
    @supplier_location.supplier = current_supplier
    if @supplier_location.save
      suppliers_supplier_location_path(@supplier_location)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @supplier_location.update(supplier_location_params)
      suppliers_supplier_location_path(@supplier_location)
    else
      render :edit
    end
  end

  def destroy
    if @supplier_location.destroy
      suppliers_path
    else
      suppliers_path
    end
  end

  private

  def set_supplier_location
    @supplier_location = SupplierLocation.find(params[:id])
  end

  def supplier_location_params
    params.require(:supplier_location).permit(:name)
  end
end