class Offtakers::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    if session[:pending_location]
      @offtaker_location = OfftakerLocation.new(session[:pending_location])
      @offtaker_location.offtaker = resource
      @offtaker_location.save
      session.delete(:pending_location)
      session[:first_visit] = true
      offtakers_offtaker_location_path(@offtaker_location)
    else
      session.delete(:first_visit)
      new_offtakers_offtaker_location_path
    end
  end

  
end