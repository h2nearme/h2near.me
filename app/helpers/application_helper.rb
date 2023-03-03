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

  def road_breakdown(value_breakdown)
  end

  def pipeline_breakdown(value_breakdown)
    production = (value_breakdown['req_offtaker_h2'].to_f * value_breakdown['cost_secondary_h2'].to_f).round(2)
    compression = 0
    purification = (value_breakdown['req_offtaker_h2'].to_f * value_breakdown['get_purity_costs'].to_f).round(2) 
    transport = value_breakdown['pipeline_transport_costs'].to_f.round(2)
    total = production + compression + purification + transport
    return {
      production: production,
      compression: compression,
      purification: purification,
      transport: transport,
      total: total,
      production_percent: (production / total * 100).ceil,
      compression_percent: (compression / total * 100).ceil,
      purification_percent: (purification / total * 100).ceil,
      transport_percent: (transport / total * 100).ceil
    }
  end

  def road_breakdown(value_breakdown)
    production = (value_breakdown['req_offtaker_h2'].to_f * value_breakdown['cost_secondary_h2'].to_f).round(2)
    compression = (value_breakdown['req_offtaker_h2'].to_f * value_breakdown['road_compression_and_storage_costs'].to_f).round(2)
    purification = (value_breakdown['req_offtaker_h2'].to_f * value_breakdown['get_purity_costs'].to_f).round(2)
    transport = (value_breakdown['req_offtaker_h2'].to_f * value_breakdown['road_transport_costs'].to_f).round(2)
    total = production + compression + purification + transport
    return {
      production: production,
      compression: compression,
      purification: purification,
      transport: transport,
      total: total,
      production_percent: (production / total * 100).ceil,
      compression_percent: (compression / total * 100).ceil,
      purification_percent: (purification / total * 100).ceil,
      transport_percent: (transport / total * 100).ceil
        }
  end
end
