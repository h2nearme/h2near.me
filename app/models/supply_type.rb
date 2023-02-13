class SupplyType < ApplicationRecord
    belongs_to :supplier_location
    has_many :scenarios, through: :supplier_locations
end
