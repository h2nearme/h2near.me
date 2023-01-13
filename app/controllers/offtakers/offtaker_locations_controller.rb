class OfftakerLocations < ApplicationController
  before_action :set_offtaker_location, only: [:show, :edit, :update, :destroy]

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

  def set_offtaker_location
  end

  def offtaker_location_params
    params.require(:offtaker_location).permit(:name)
  end
end