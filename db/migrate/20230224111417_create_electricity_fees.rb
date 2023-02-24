class CreateElectricityFees < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_fees do |t|
      t.float :value

      t.timestamps
    end
  end
end
