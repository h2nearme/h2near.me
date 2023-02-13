class OfftakerLocation < ApplicationRecord
  include Hashid::Rails

  belongs_to :offtaker
  has_many :scenarios, dependent: :destroy
  geocoded_by :coordinates

  after_save :set_prefixed_id

  validates :name, presence: true
  validates :required_hydrogen_volume, presence: true
  validates :required_hydrogen_pressure, presence: true

  def coordinates
    [self.latitude, self.longitude]
  end

  def address
    if self.house_nr && self.postal_code
      "#{self.house_nr} - #{self.postal_code}"
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
  
end
