class SupplierLocation < ApplicationRecord
  include Hashid::Rails

  belongs_to :supplier
  has_many :scenarios
  geocoded_by :coordinates

  after_save :set_prefixed_id

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
      self.prefixed_id = "s_#{self.id}"
      self.save
    end
  end

end
