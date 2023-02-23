class SupplierLocation < ApplicationRecord
  include Hashid::Rails

  belongs_to :supplier
  has_many :scenarios
  has_many :supply_types, inverse_of: :supplier_location
  accepts_nested_attributes_for :supply_types, reject_if: :all_blank, allow_destroy: true
  geocoded_by :coordinates

  after_save :set_prefixed_id

  validates :name, presence: true

  def coordinates
    [self.latitude, self.longitude]
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
      self.prefixed_id = "s_#{self.id}"
      self.save
    end
  end

end
