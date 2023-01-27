class CostCalculationService

  def initialize(scenario)
    @scenario = scenario
    @req_offtaker_h2 = scenario.offtaker_location.req_hydrogen_vol.to_f
    @req_offtaker_o2 = scenario.offtaker_location.req_oxygen_vol.to_f
    @re_offtaker_h2_purity = scenario.offtaker_location.required_purity_hydrogen
    @scenario_distance_pipeline = scenario.distance_pipeline.to_f
    @scenario_distance_lorry = scenario.distance_lorry.to_f
    @capex_opex_elec = ENV['CAPEX_OPEX_ELECTROLYSER'].to_f  # GBP per KG
    @capex_pipe = ENV['CAPEX_PIPELINE'].to_f  # GBP per KG
    @opex_pipe = ENV['OPEX_PIPELINE'].to_f  # GBP per KG
    @grid_fees = ENV['GRID_FEES'].to_f  # GBP per KG
    @taxes = ENV['TAXES'].to_f  # GBP per KG
    @ws_elec_costs = ENV['COSTS_WHOLESALE_ELECTRICITY'].to_f  # GBP per KG
    @costs_lorry_h2 = ENV['COSTS_TRANSPORT_LORRY_H2'].to_f  # GBP per KM
    @costs_lorry_o2 = ENV['COSTS_TRANSPORT_LORRY_O2'].to_f  # GBP per KM
    @costs_h2_300_comp = ENV['COSTS_H2_300_COMPRESSION'].to_f  # GBP per KG
    @costs_h2_700_comp = ENV['COSTS_H2_700_COMPRESSION'].to_f  # GBP per KG
    @costs_h2_300_storage = ENV['COSTS_H2_300_STORAGE'].to_f  # GBP per KG
    @costs_h2_700_storage = ENV['COSTS_H2_300_STORAGE'].to_f  # GBP per KG
    @costs_o2_300_comp = ENV['COSTS_O2_300_COMPRESSION'].to_f  # GBP per KG
    @costs_o2_700_comp = ENV['COSTS_O2_700_COMPRESSION'].to_f  # GBP per KG
    @costs_o2_300_storage = ENV['COSTS_O2_300_STORAGE'].to_f  # GBP per KG
    @costs_o2_700_storage = ENV['COSTS_O2_300_STORAGE'].to_f  # GBP per KG
    @drtfc_discount = ENV['DRTFC_DISCOUNT'].to_f  # GBP per KG
    @costs_h2_import = ENV['COSTS_H2_IMPORT'].to_f  # GBP per KG
    
  end

  def call
    calculation
  end

  private

  def get_current_electricty_price
    # api call to get current price of electricty
  end

  def calculation
    # grid_fees_purity = {
    #   pure:500,
    #   ultra_pure: 600,
    #   high_pure:550
    # }
    # grid_fees_purity[@re_offtaker_h2_purity.to_sym]

    # if (scenario.supplier_location.has_drtfc == TRUE) then discount else 0

    total_cost_h2 = (@capex_opex_elec + @grid_fees + @taxes + @ws_elec_costs) - @drtfc_discount
    total_cost_transport_h2_lorry = @costs_lorry_h2 * @scenario_distance_pipeline # needs to change to distance_lorry
    total_costs_h2_road = @req_offtaker_h2 * (total_cost_h2 + @costs_h2_300_comp + @costs_h2_300_storage + total_cost_transport_h2_lorry)

    total_cost_transport_h2_pipeline = (@capex_pipe * @scenario_distance_pipeline) + (@opex_pipe * @scenario_distance_pipeline)
    total_costs_h2_pipeline = (@req_offtaker_h2 * total_cost_h2) + total_cost_transport_h2_pipeline

    total_cost_o2 = (@capex_opex_elec + @grid_fees + @taxes + (@ws_elec_costs*8) ) - (@drtfc_discount*8)
    total_cost_transport_o2 = @costs_lorry_o2 * @scenario_distance_pipeline
    total_costs_o2_road = @req_offtaker_o2 * (total_cost_o2 + @costs_o2_300_comp + @costs_o2_300_storage + total_cost_transport_o2)

    total_costs_h2_import = @req_offtaker_h2 * @costs_h2_import

    if @req_offtaker_h2 > 0
      @scenario.update(
        costs_road_h2: total_costs_h2_road,
        costs_pipeline_h2: total_costs_h2_pipeline,
        costs_import_h2: total_costs_h2_import
        )
    end

    if @req_offtaker_o2 > 0
      @scenario.update(costs_road_o2: total_costs_o2_road)
    end

  end
end