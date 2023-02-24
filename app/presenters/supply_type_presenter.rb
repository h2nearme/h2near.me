include ActionView::Helpers::NumberHelper

class SupplyTypePresenter
  def initialize(supply_type)
    @supply_type = supply_type
  end

  def compression_costs
     "£ #{number_with_precision(@supply_type.compression_costs, precision: 2, delimiter: '.', separator: ',')}"
  end

  def transport_costs
    "£ #{number_with_precision(@supply_type.transport_costs, precision: 2, delimiter: '.', separator: ',')}"
  end

  def description
    case @supply_type.name
    when 'Standard'
      'Standard purity'
    when 'ITMs'
      '99.99% purity'
    when 'Pure'
      '99.9999% purity'
    when 'High pure'
      '99.99999% purity'
    when 'Ultrapure'
      '99.999999% purity'
    end
  end
end