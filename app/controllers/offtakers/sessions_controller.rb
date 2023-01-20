class Offtakers::SessionsController < Devise::SessionsController
  protected
  
  def after_sign_in_path_for(resource)
    offtakers_path
  end

end