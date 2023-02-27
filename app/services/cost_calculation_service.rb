require "json"
require "open-uri"

class CostCalculationService

  def initialize(scenario)
    @scenario = scenario
    @req_offtaker_h2 = scenario.offtaker_location.required_hydrogen_volume.to_f #KG per day (12 hours)
    @re_offtaker_h2_purity = scenario.offtaker_location.required_hydrogen_purity
    @scenario_distance = scenario.distance.to_f
    @req_offtaker_compression_h2 = scenario.offtaker_location.required_hydrogen_pressure
    @offtaker_own_transport = scenario.offtaker_location.own_transport
    @scenario_hydrogen_purity = scenario.offtaker_location.required_hydrogen_purity 
    @investment_period = scenario.offtaker_location.investment_period_years # years
    @contract_period = scenario.offtaker_location.contract_period_years # years
    @capex_opex_elec = ENV['CAPEX_OPEX_ELECTROLYSER'].to_f  # GBP per KG
    @costs_elec_perkg_h2 = ENV['ELECTRICITY_PER_KG_H2'].to_f #KWH per KG H2
    @capex_pipe = ENV['CAPEX_PIPELINE'].to_f  # GBP per KG
    @opex_pipe = ENV['OPEX_PIPELINE'].to_f  # GBP per KG
    @grid_fees = ENV['GRID_FEES'].to_f  # GBP per KG
    @taxes = ENV['TAXES'].to_f  # GBP per KG
    @costs_lorry_h2 = ENV['COSTS_TRANSPORT_LORRY_H2'].to_f  # GBP per KM
    @costs_h2_350_comp = ENV['COSTS_H2_350_COMPRESSION'].to_f  # GBP per KG
    @costs_h2_700_comp = ENV['COSTS_H2_700_COMPRESSION'].to_f  # GBP per KG
    @costs_h2_350_storage = ENV['COSTS_H2_350_STORAGE'].to_f  # GBP per KG
    @costs_h2_700_storage = ENV['COSTS_H2_700_STORAGE'].to_f  # GBP per KG
    @drtfc_discount = ENV['DRTFC_DISCOUNT'].to_f  # GBP per KG
    @costs_h2_import = ENV['COSTS_H2_IMPORT'].to_f  # GBP per KG
    @energy_price_ratio = ENV['ENERGY_PRICE_RATIO_GB_NI'].to_f 
    @costs_purification_twonines = ENV['COST_PURIFICATION_TWONINES'].to_f
    @costs_purification_fournines = ENV['COST_PURIFICATION_FOURNINES'].to_f
    @costs_purification_fivenines = ENV['COST_PURIFICATION_FIVENINES'].to_f
    @costs_purification_sixnines = ENV['COST_PURIFICATION_SIXNINES'].to_f
    @ws_elec_costs = get_current_electricty_price || ENV['COSTS_WHOLESALE_ELECTRICITY'].to_f  # GBP per KWH
  end

  def call
    calculation
  end

  private

  def get_current_electricty_price
    electricity_fee = ElectricityFee.first || ElectricityFee.new
    if electricity_fee.new_record? || electricity_fee.updated_at < 1.day.ago
      begin
        today = Date.tomorrow.strftime("%d-%m-%Y")
        url = "https://odegdcpnma.execute-api.eu-west-2.amazonaws.com/development/prices?dno=14&voltage=HV&start=#{today}&end=#{today}"
        cost_serialized = URI.open(url).read
        cost_data = JSON.parse(cost_serialized)
        cost =  (cost_data['data']['data'][0]['Overall'] / 100) * @energy_price_ratio
        electricity_fee.value = (cost > 0 ? cost : nil)
        electricity_fee.save
        return electricity_fee.value
      rescue OpenURI::HTTPError
        return nil
      end
    else
      electricity_fee.value
    end
  end

  def cost_secondary_h2
    # This function is used to calculate the secondary costs to transport hydrogen 
    # This value is the same for road & pipeline
    total_cost_wholesale_electricty = @costs_elec_perkg_h2 * @ws_elec_costs
    return (@capex_opex_elec + @grid_fees + @taxes + total_cost_wholesale_electricty) - @drtfc_discount
  end

  def get_purity_costs
    purifiction_cost = {
      'Standard': 0,
      'ITMs': @costs_purification_twonines,
      'Pure': @costs_purification_fournines,
      'High pure': @costs_purification_fivenines,
      'Ultrapure': @costs_purification_sixnines
    }
    return purifiction_cost[@scenario_hydrogen_purity.to_sym]

  end

  def cost_road
    # This function is used to calculate the costs to transport hydrogen over road between
    # an offtaker and a supplier. It considers the different type of required compression.
    
    # Arguements: 
    #   required compression (Offtaker)
    
    # Returns:
    #    total cost over raod

    costs_lorry = (@offtaker_own_transport ? 0 : @costs_lorry_h2)
    total_cost_transport_h2_lorry = costs_lorry * @scenario_distance
    total_costs_h2_road = @req_offtaker_h2 * (cost_secondary_h2 + compression_and_storage_costs + total_cost_transport_h2_lorry + get_purity_costs)
    return total_costs_h2_road
  end

  def compression_and_storage_costs
    if @req_offtaker_compression_h2 == 350.0
      @costs_h2_350_comp + @costs_h2_350_storage
    elsif @req_offtaker_compression_h2 == 700.0
      @costs_h2_700_comp + @costs_h2_700_storage
    else
      0
    end
  end

  def cost_pipeline
    # This function is used to calculate the costs to transport hydrogen through a pipeline
    # from a supplier to an offtaker.

    investment_period = 1
    if @investment_period && @investment_period > 0
      investment_period = @investment_period
    else
      investment_period = 1
    end

    total_cost_transport_h2_pipeline = ( (@capex_pipe / (investment_period * 365)) * @scenario_distance) + ( ((@opex_pipe / 365 ) * @contract_period ) * @scenario_distance)
    total_costs_h2_pipeline = (@req_offtaker_h2 * (cost_secondary_h2 + get_purity_costs ) ) + total_cost_transport_h2_pipeline
    return total_costs_h2_pipeline
  end


  def cost_import
    total_costs_h2_import = @req_offtaker_h2 * (@costs_h2_import + get_purity_costs )
    return total_costs_h2_import
  end

  def calculation
    # grid_fees_purity = {
    #   pure:500,
    #   ultra_pure: 600,
    #   high_pure:550
    # }
    # grid_fees_purity[@re_offtaker_h2_purity.to_sym]

    # if (scenario.supplier_location.has_drtfc == TRUE) then discount else 0

    # if the required offtaker compression for hydrogen is 350 or both, then calculate cost of transport 
    # over road with the respective compression



    attributes = {}
    if @req_offtaker_h2 > 0
      attributes.merge!(
        {
          costs_road: cost_road,
          costs_pipeline: cost_pipeline,
          costs_import: cost_import,
          value_breakdown: {
            req_offtaker_h2: @req_offtaker_h2,
            re_offtaker_h2_purity: @re_offtaker_h2_purity,
            scenario_distance: @scenario_distance,
            req_offtaker_compression_h2: @req_offtaker_compression_h2,
            offtaker_own_transport: @offtaker_own_transport,
            scenario_hydrogen_purity: @scenario_hydrogen_purity,
            investment_period: @investment_period,
            contract_period: @contract_period,
            capex_opex_elec: @capex_opex_elec,
            costs_elec_perkg_h2: @costs_elec_perkg_h2,
            capex_pipe: @capex_pipe,
            opex_pipe: @opex_pipe,
            grid_fees: @grid_fees,
            taxes: @taxes,
            costs_lorry_h2: @costs_lorry_h2,
            costs_h2_350_comp: @costs_h2_350_comp,
            costs_h2_700_comp: @costs_h2_700_comp,
            costs_h2_350_storage: @costs_h2_350_storage,
            costs_h2_700_storage: @costs_h2_700_storage,
            drtfc_discount: @drtfc_discount,
            costs_h2_import: @costs_h2_import,
            energy_price_ratio: @energy_price_ratio,
            costs_purification_twonines: @costs_purification_twonines,
            costs_purification_fournines: @costs_purification_fournines,
            costs_purification_fivenines: @costs_purification_fivenines,
            costs_purification_sixnines: @costs_purification_sixnines,
            ws_elec_costs: @ws_elec_costs,
            compression_and_storage_costs: compression_and_storage_costs,
            cost_secondary_h2: cost_secondary_h2,
            get_purity_costs: get_purity_costs
          }.to_json
        }
      )
    end

    return attributes
  end
end