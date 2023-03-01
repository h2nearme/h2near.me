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

  def self.generate_geojson
    {
      "type":"FeatureCollection",
      "features": generate_features
    }.to_json
  end

  def self.generate_features
    self.all.map do |offtaker_location|
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
  
end
