include ActionView::Helpers::NumberHelper

class ScenarioPresenter
  def initialize(scenario)
    @scenario = scenario
  end

  def distance
    "#{number_with_precision(@scenario.distance, precision: 2, delimiter: '.', separator: ',')} km"
  end

  def costs_road
    "£ #{number_with_precision(@scenario.costs_road, precision: 2, delimiter: '.', separator: ',')}"
  end

  def costs_pipeline
    "£ #{number_with_precision(@scenario.costs_pipeline, precision: 2, delimiter: '.', separator: ',')}"
  end

  def costs_import
    "£ #{number_with_precision(@scenario.costs_import, precision: 2, delimiter: '.', separator: ',')}"
  end

  def required_hydrogen_volume
  "#{number_with_precision(@scenario.offtaker_location.required_hydrogen_volume, precision: 2, delimiter: '.', separator: ',')} kg"
  end

  def required_hydrogen_volume?
    @scenario.offtaker_location.required_hydrogen_volume
  end

  def required_oxygen_volume
  "#{number_with_precision(@scenario.offtaker_location.required_oxygen_volume, precision: 2, delimiter: '.', separator: ',')} kg"
  end

  def required_oxygen_volume?
    @scenario.offtaker_location.required_oxygen_volume
  end

  def cheapest_option(cheapest)
    "#{@scenario.compare_cheapest_h2(cheapest)&.capitalize} is the cheapest option at </br> £ #{number_with_precision(cheapest, precision: 2, delimiter: '.', separator: ',')}".html_safe
  end
end