class Offtakers::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    new_offtakers_offtaker_location_path
  end
  
end