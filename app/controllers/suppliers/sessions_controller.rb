class Suppliers::SessionsController < Devise::SessionsController
  protected
  
  def after_sign_in_path_for(resource)
    suppliers_path
  end

end