class SupplyType < ApplicationRecord

    belongs_to :supplier_locations
    has_many :scenarios, through: :supplier_locations
end
