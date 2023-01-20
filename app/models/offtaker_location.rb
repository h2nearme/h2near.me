class OfftakerLocation < ApplicationRecord
  belongs_to :offtaker

  def address
    "#{self.house_nr} - #{self.postal_code}"
  end
end
