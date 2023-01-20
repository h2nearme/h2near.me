class OfftakerLocation < ApplicationRecord
  belongs_to :offtaker
  after_save :set_prefixed_id

  def address
    "#{self.house_nr} - #{self.postal_code}"
  end

  def set_prefixed_id
    if self.prefixed_id.nil?
      self.prefixed_id = "o_#{self.id}"
      self.save
    end
  end
  
end
