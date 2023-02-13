class SupplyType < ApplicationRecord
    belongs_to :supplier_location
    has_many :scenarios, through: :supplier_locations

    validates :name, presence: true

    def present
        SupplyTypePresenter.new(self)
    end
end
