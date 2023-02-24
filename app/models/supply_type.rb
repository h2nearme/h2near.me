class SupplyType < ApplicationRecord
    belongs_to :supplier_location
    has_many :scenarios, through: :supplier_locations
    has_one_attached :purity_proof
    has_one_attached :supply_proof

    validates :name, presence: true

    def present
        SupplyTypePresenter.new(self)
    end
end
