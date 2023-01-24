class Offtakers::OfftakerLocationsController < ApplicationController
  before_action :set_offtaker_location, only: [:show, :edit, :update, :destroy]

  def dashboard
    @offtaker_locations = current_offtaker.offtaker_locations.paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def new
    @offtaker_location = OfftakerLocation.new
  end

  def create
    @offtaker_location = OfftakerLocation.new(offtaker_location_params)
    @offtaker_location.offtaker = current_offtaker
    if @offtaker_location.save
      redirect_to offtakers_offtaker_location_path(@offtaker_location)
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