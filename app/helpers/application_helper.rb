module ApplicationHelper
  def devise_controllers
    params[:controller].include?('devise') || params[:controller].include?('registrations') || params[:controller].include?('sessions') 
  end

  def set_user_type
    if admin_signed_in?  || request.path.include?('admin')
    'admin'
    elsif offtaker_signed_in? || request.path.include?('offtakers')
      'offtaker'
    elsif supplier_signed_in? || request.path.include?('suppliers')
      'supplier'
    else
      'none'
    end
  end
end
