class Offtaker < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :offtaker_locations
  has_many :scenarios, through: :offtaker_locations

  def self.compose_chart_data(start_date)
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    past_year_offtakers = Offtaker.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date))
    grouped_by_month = past_year_offtakers.group_by {|offtaker| offtaker.created_at.strftime("%b") }
    formatted_months = grouped_by_month.map {|month, offtakers| [month, (offtakers.inject(0) do |sum, offtaker|
      sum += yield(offtaker)
    end)]}
    padded_months = months.map do |month| 
      month_with_data = formatted_months.find {|month_name, sum| month == month_name }
      [month, (month_with_data ? month_with_data[1].round(2) : 0)]
    end
    return padded_months
  end

  def self.set_history_for_chart_month_creation(start_date)
    compose_chart_data(start_date) do |offtaker|
      1
    end
  end

  def self.set_history_for_chart_month_scenarios_per_offtaker(start_date)
    compose_chart_data(start_date) do |offtaker|
      offtaker.scenarios.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date)).count
    end
  end
end
