class Offtakers::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if session[:pending_location]
      @offtaker_location = OfftakerLocation.new(session[:pending_location])
      @offtaker_location.offtaker = resource
      @offtaker_location.save
      session.delete(:pending_location)
      session[:first_visit] = true
      offtakers_offtaker_location_path(@offtaker_location)
    else
      session.delete(:first_visit)
      offtakers_path
    end
  end

end