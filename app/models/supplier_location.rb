class SupplierLocation < ApplicationRecord
  belongs_to :supplier

  after_save :set_prefixed_id

  def address
    "#{self.house_nr} - #{self.postal_code}"
  end

  def set_prefixed_id
    if self.prefixed_id.nil?
      self.prefixed_id = "s_#{self.id}"
      self.save
    end
  end

end
