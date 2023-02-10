class CostCalculationService

  def initialize(scenario)
    @scenario = scenario
    @req_offtaker_h2 = scenario.offtaker_location.req_hydrogen_vol.to_f #KG per day (12 hours)
    @req_offtaker_o2 = scenario.offtaker_location.req_oxygen_vol.to_f
    @re_offtaker_h2_purity = scenario.offtaker_location.required_purity_hydrogen
    @scenario_distance_pipeline = scenario.distance_pipeline.to_f
    @scenario_distance_lorry = scenario.distance_lorry.to_f
    @req_offtaker_compression_h2 = scenario.offtaker_location.req_pressure_hydrogen
    @req_offtaker_compression_02 = scenario.offtaker_location.req_pressure_oxygen
    @offtaker_own_transport = scenario.offtaker_location.own_transport
    @scenario_hydrogen_purity = scenario.offtaker_locations.required_hydrogen_purity 
    @investment_period = scenario.offtaker_location.investment_period_years # years
    @contract_period = scenario.offtaker_location.contract_period_years # years
    @capex_opex_elec = ENV['CAPEX_OPEX_ELECTROLYSER'].to_f  # GBP per KG
    @costs_elec_perkg_h2 = ENV['ELECTRICITY_PER_KG_H2'].to_f #KWH per KG H2
    @capex_pipe = ENV['CAPEX_PIPELINE'].to_f  # GBP per KG
    @opex_pipe = ENV['OPEX_PIPELINE'].to_f  # GBP per KG
    @grid_fees = ENV['GRID_FEES'].to_f  # GBP per KG
    @taxes = ENV['TAXES'].to_f  # GBP per KG
    @ws_elec_costs = ENV['COSTS_WHOLESALE_ELECTRICITY'].to_f  # GBP per KWH
    @costs_lorry_h2 = ENV['COSTS_TRANSPORT_LORRY_H2'].to_f  # GBP per KM
    @costs_h2_350_comp = ENV['COSTS_H2_350_COMPRESSION'].to_f  # GBP per KG
    @costs_h2_700_comp = ENV['COSTS_H2_700_COMPRESSION'].to_f  # GBP per KG
    @costs_h2_350_storage = ENV['COSTS_H2_350_STORAGE'].to_f  # GBP per KG
    @costs_h2_700_storage = ENV['COSTS_H2_700_STORAGE'].to_f  # GBP per KG
    @drtfc_discount = ENV['DRTFC_DISCOUNT'].to_f  # GBP per KG
    @costs_h2_import = ENV['COSTS_H2_IMPORT'].to_f  # GBP per KG
    @energy_price_ratio = ENV['ENERGY_PRCE_RATIO_GB_NI'].to_f 
    @costs_purification_twonines = ENV['COST_PURIFICATION_TWONINES'].to_f
    @costs_purification_fournines = ENV['COST_PURIFICATION_FOURNINES'].to_f
    @costs_purification_fivenines = ENV['COST_PURIFICATION_FIVENINES'].to_f
    @costs_purification_sixnines = ENV['COST_PURIFICATION_SIXNINES'].to_f
  end

  def call
    calculation
  end

  private

  def get_current_electricty_price
    # api call to get current price of electricty
  end

  def cost_secondary_h2
    # This function is used to calculate the secondary costs to transport hydrogen 
    # This value is the same for road & pipeline
    total_cost_wholesale_electricty = @costs_elec_perkg_h2 * @ws_elec_costs
    return (@capex_opex_elec + @grid_fees + @taxes + total_cost_wholesale_electricty) - @drtfc_discount
  end

  def get_purity_costs(hydrogen_purity)
    purifaction_cost = {
      'Standard' : 0,
      'ITMs' : @costs_purification_twonines,
      'Pure' : @costs_purification_fournines,
      'High pure' : @costs_purification_fivenines,
      'Ultrapure' : @costs_purification_sixnines
    }
    return purifaction_cost[hydrogen_purity]

  end

  def cost_road_h2(required_compression, required_purity)
    # This function is used to calculate the costs to transport hydrogen over road between
    # an offtaker and a supplier. It considers the different type of required compression.
    
    # Arguements: 
    #   required compression (Offtaker)
    
    # Returns:
    #    total cost over raod

    if required_compression == "300"
      compression_costs = @costs_h2_300_comp
      storage_costs = @costs_h2_300_storage
    elsif required_compression == "700"
      compression_costs = @costs_h2_700_comp
      storage_costs = @costs_h2_300_storage
    end
    total_cost_transport_h2_lorry = @costs_lorry_h2 * @scenario_distance_pipeline # needs to change to distance_lorry
    total_costs_h2_road = @req_offtaker_h2 * (cost_secondary_h2 + compression_costs + storage_costs + total_cost_transport_h2_lorry + get_purity_costs(required_purity))
    return total_costs_h2_road
  end

  def cost_pipeline_h2(required_purity)
    # This function is used to calculate the costs to transport hydrogen through a pipeline
    # from a supplier to an offtaker.

    total_cost_transport_h2_pipeline = ( (@capex_pipe / @investment_period) * @scenario_distance_pipeline) + ( ((@opex_pipe / 365 ) * @contract_period ) * @scenario_distance_pipeline)
    total_costs_h2_pipeline = (@req_offtaker_h2 * (cost_secondary_h2 + get_purity_costs(required_purity) ) ) + total_cost_transport_h2_pipeline
    return total_costs_h2_pipeline
  end

  # def cost_road_o2(pressure)
  #   total_cost_o2 = (@capex_opex_elec + @grid_fees + @taxes + (@ws_elec_costs*8) ) - (@drtfc_discount*8)
  #   total_cost_transport_o2 = @costs_lorry_o2 * @scenario_distance_pipeline
  #   total_costs_o2_road = @req_offtaker_o2 * (total_cost_o2 + @costs_o2_300_comp + @costs_o2_300_storage + total_cost_transport_o2)
  #   return total_costs_o2_road
  # end

  def cost_import_h2(required_purity)
    total_costs_h2_import = @req_offtaker_h2 * (@costs_h2_import + get_purity_costs(required_purity) )
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

    # if the required offtaker compression for hydrogen is 300 or both, then calculate cost of transport 
    # over road with the respective compression



    attributes = {}
    if @req_offtaker_h2 > 0
      attributes.merge!(
        {
          costs_road_h2: cost_road_h2(@required_compression, @scenario_hydrogen_purity),
          costs_pipeline_h2: cost_pipeline_h2(@scenario_hydrogen_purity),
          costs_import_h2: cost_import_h2(@scenario_hydrogen_purity)
        }
      )
    end

    # if @req_offtaker_o2 > 0
    #  attributes.merge!(
    #   {
    #     costs_road_o2: total_costs_o2_road
    #   }
    #  )
    # end
    return attributes
  end
end