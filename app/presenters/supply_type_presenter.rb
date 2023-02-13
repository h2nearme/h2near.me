include ActionView::Helpers::NumberHelper

class SupplyTypePresenter
  def initialize(supply_type)
    @supply_type = supply_type
  end

  def compression_costs
     "£#{number_with_precision(@supply_type.compression_costs, precision: 2, delimiter: '.', separator: ',')}"
  end

  def transport_costs
    "£#{number_with_precision(@supply_type.transport_costs, precision: 2, delimiter: '.', separator: ',')}"
 end
end