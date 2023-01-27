class CostCalculationService

  def initialize(scenario)
    @scenario = scenario
  end

  def call
    calculation
  end

  private

  def calculation
    "This is where the magic happens"
  end
end