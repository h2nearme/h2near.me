class OfftakerLocation < ApplicationRecord
  belongs_to :offtaker

  after_save :set_prefixed_id

  def set_prefixed_id
    if self.prefixed_id.nil?
      self.prefixed_id = "s_#{self.id}"
      self.save
    end
  end
  
end
