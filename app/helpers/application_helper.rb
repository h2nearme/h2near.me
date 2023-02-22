module ApplicationHelper
  def devise_controllers
    params[:controller].include?('devise') || params[:controller].include?('registrations') || params[:controller].include?('sessions') 
  end

  def set_user_type
    if offtaker_signed_in? || params[:controller].include?('offtakers')
      'offtaker'
    elsif supplier_signed_in? || params[:controller].include?('suppliers')
      'supplier'
    else
      'none'
    end
  end
end
