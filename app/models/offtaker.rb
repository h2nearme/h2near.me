class Offtaker < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :offtaker_locations
  has_many :scenarios, through: :offtaker_locations

  def self.compose_chart_data_weekly(start_date)
    past_week_dates = (start_date..(start_date + 6.days).to_date).map{ |date| date }
    past_week_offtakers = Offtaker.where(created_at: (start_date..(start_date + 6.days).to_date))
    formatted_dates = past_week_dates.map do |date|
      offtakers = past_week_offtakers.select {|offtaker| offtaker.created_at.to_date == date }
      [date.strftime("%a"), (offtakers.inject(0) do |sum, offtaker|
        sum += yield(offtaker)
      end)]
    end
    return formatted_dates
  end

  def self.compose_chart_data_monthly(start_date)
    week_numbers_this_month = (start_date.beginning_of_month.to_date..start_date.end_of_month.to_date).uniq {|date| date.strftime("%U")}.map {|date| date.strftime("%U").to_i}
    past_month_offtakers = Offtaker.where(created_at: (start_date.beginning_of_month.to_date..start_date.end_of_month.to_date))
    grouped_by_weeknumber = past_month_offtakers.group_by {|offtaker| offtaker.created_at.strftime("%U").to_i }

    formatted_weeks = grouped_by_weeknumber.map {|week_number, offtakers| [week_number, (offtakers.inject(0) do |sum, offtaker|
      sum += yield(offtaker)
    end)]}
    padded_weeks = week_numbers_this_month.map do |number| 
      week_with_data = formatted_weeks.find {|week_number, sum| number == week_number }
      ["Week #{number} | #{start_date.strftime("%b")}", (week_with_data ? week_with_data[1].round(2) : 0)]
    end
    return padded_weeks
  end

  def self.compose_chart_data_yearly(start_date)
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

  def self.set_history_for_chart_creation(start_date, variant)
    case variant
    when 'weekly'
      compose_chart_data_weekly(start_date) do |offtaker|
        1
      end
    when 'monthly'
      compose_chart_data_monthly(start_date) do |offtaker|
        1
      end
    when 'yearly'
      compose_chart_data_yearly(start_date) do |offtaker|
        1
      end
    end
  end

  def self.set_history_for_chart_scenarios_per_offtaker(start_date, variant)
    case variant
    when 'weekly'
      compose_chart_data_weekly(start_date) do |offtaker|
        offtaker.scenarios.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date)).count
      end
    when 'monthly'
      compose_chart_data_monthly(start_date) do |offtaker|
        offtaker.scenarios.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date)).count
      end
    when 'yearly'
      compose_chart_data_yearly(start_date) do |offtaker|
        offtaker.scenarios.where(created_at: (start_date.beginning_of_year.to_date..start_date.end_of_year.to_date)).count
      end
    end
  end

end
