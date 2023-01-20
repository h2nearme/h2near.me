module ApplicationHelper
  def devise_controllers
    params[:controller].include?('devise') || params[:controller].include?('registrations') || params[:controller].include?('sessions') 
  end
end
