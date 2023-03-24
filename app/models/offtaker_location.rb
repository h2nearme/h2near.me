class OfftakerLocation < ApplicationRecord
  include Hashid::Rails

  belongs_to :offtaker
  has_many :scenarios, dependent: :destroy
  geocoded_by :coordinates

  after_save :set_prefixed_id
  after_save :update_scenarios

  validates :name, presence: true
  validates :required_hydrogen_volume, presence: true
  validates :required_hydrogen_pressure, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :investment_period_years, numericality: { greater_than: 0 }
  validates :contract_period_years, numericality: { greater_than: 0 }


  def coordinates
    [self.latitude, self.longitude]
  end

  def reverse_coordinates
    [self.longitude, self.latitude]
  end

  def address
    if self.house_nr && self.postal_code
      "#{self.house_nr}#{"- #{self.postal_code}" unless self.postal_code.blank?}"
    else
      ""
    end
  end

  def set_prefixed_id
    if self.prefixed_id.nil?
      self.prefixed_id = "o_#{self.id}"
      self.save
    end
  end

  def update_scenarios
    self.scenarios.each do |scenario|
      scenario.run_calculations
      scenario.save
    end
  end

  def self.generate_geojson(filter_types)
    {
      "type":"FeatureCollection",
      "features": generate_features(filter_types)
    }.to_json
  end

  def self.generate_features(filter_types)
    if filter_types.any?
      offtaker_locations = self.where(required_hydrogen_purity: filter_types.map {|type| type.downcase })
    else
      offtaker_locations = self.all
    end
    offtaker_locations.map do |offtaker_location|
      {
        "type":"Feature",
        "properties":{ 
          "volume": offtaker_location.required_hydrogen_volume,
          "name": offtaker_location.name,
          "id": offtaker_location.hashid
        },
        "geometry":{
          "type":"Point",
          "coordinates":offtaker_location.reverse_coordinates
        }
      }
    end
  end

  def self.compose_chart_data_weekly(start_date)
    past_week_dates = (start_date..(start_date + 6.days).to_date).map{ |date| date }
    past_week_offtaker_locations = OfftakerLocation.where(created_at: (start_date..(start_date + 6.days).to_date))
    formatted_dates = past_week_dates.map do |date|
      offtaker_locations = past_week_offtaker_locations.select {|offtaker_location| offtaker_location.created_at.to_date == date }
      [date.strftime("%a"), (offtaker_locations.inject(0) do |sum, offtaker_location|
        sum += yield(offtaker_location)
      end)]
    end
    return formatted_dates
  end

  def self.compose_chart_data_monthly(start_date)
    week_numbers_this_month = (start_date.beginning_of_month.to_date..start_date.end_of_month.to_date).uniq {|date| date.strftime("%U")}.map {|date| date.strftime("%U").to_i}
    past_month_offtaker_locations = OfftakerLocation.where(created_at: (start_date.beginning_of_month.to_date..start_date.end_of_month.to_date))
    grouped_by_weeknumber = past_month_offtaker_locations.group_by {|offtaker_location| offtaker_location.created_at.strftime("%U").to_i }

    formatted_weeks = grouped_by_weeknumber.map {|week_number, offtaker_locations| [week_number, (offtaker_locations.inject(0) do |sum, offtaker_location|
      sum += yield(offtaker_location)
    end)]}
    padded_weeks = week_numbers_this_month.map do |number| 
      week_with_data = formatted_weeks.find {|week_number, sum| number == week_number }
      ["Week #{number} | #{start_date.strftime("%b")}", (week_with_data ? week_with_data[1].round(2) : 0)]
    end
    return padded_weeks
  end

  def self.compose_chart_data_yearly(start_date)
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    past_year_offtaker_locations = OfftakerLocation.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date))
    grouped_by_month = past_year_offtaker_locations.group_by {|offtaker_location| offtaker_location.created_at.strftime("%b") }
    formatted_months = grouped_by_month.map {|month, offtaker_locations| [month, (offtaker_locations.inject(0) do |sum, offtaker_location|
      sum += yield(offtaker_location)
    end)]}
    padded_months = months.map do |month| 
      month_with_data = formatted_months.find {|month_name, sum| month == month_name }
      [month, (month_with_data ? month_with_data[1].round(2) : 0)]
    end
    return padded_months
  end

  def self.set_history_for_chart_creation(start_date, variant)
    case variant
    when 'weekly'
      compose_chart_data_weekly(start_date) do |offtaker_location|
        1
      end
    when 'monthly'
      compose_chart_data_monthly(start_date) do |offtaker_location|
        1
      end
    when 'yearly'
      compose_chart_data_yearly(start_date) do |offtaker_location|
        1
      end
    end
  end

  def self.set_history_for_chart_volume(start_date, variant)
    case variant
    when 'weekly'
      compose_chart_data_weekly(start_date) do |offtaker_location|
        (offtaker_location&.required_hydrogen_volume || 0)
      end
    when 'monthly'
      compose_chart_data_monthly(start_date) do |offtaker_location|
        (offtaker_location&.required_hydrogen_volume || 0)
      end
    when 'yearly'
      compose_chart_data_yearly(start_date) do |offtaker_location|
        (offtaker_location&.required_hydrogen_volume || 0)
      end
    end
  end

  def self.set_history_for_chart_oxygen_interest(start_date, variant)
    case variant
    when 'weekly'
      compose_chart_data_weekly(start_date) do |offtaker_location|
        (offtaker_location&.interest_oxygen ? 1 : 0)
      end
    when 'monthly'
      compose_chart_data_monthly(start_date) do |offtaker_location|
        (offtaker_location&.interest_oxygen ? 1 : 0)
      end
    when 'yearly'
      compose_chart_data_yearly(start_date) do |offtaker_location|
        (offtaker_location&.interest_oxygen ? 1 : 0)
      end
    end
  end
  
end
