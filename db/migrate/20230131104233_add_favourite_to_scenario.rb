class AddFavouriteToScenario < ActiveRecord::Migration[7.0]
  def change
    add_column :scenarios, :favourite, :boolean, default: false
  end
end
