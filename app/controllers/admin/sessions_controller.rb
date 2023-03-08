class Admin::SessionsController < Devise::SessionsController
  protected
  
  def after_sign_in_path_for(resource)
    sign_out(current_offtaker) if current_offtaker.present?
    sign_out(current_supplier) if current_supplier.present?
    admin_path
  end

end