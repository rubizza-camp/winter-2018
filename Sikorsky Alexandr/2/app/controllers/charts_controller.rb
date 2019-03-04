class ChartsController < ApplicationController
  before_action :ingestions_data

  def ingestions_count
    render json: ingestions_data.count
   end

  def average_calories
    render json: ingestions_data.joins(:dishes).sum(:calorie_value)
  end

  private

  def ingestions_data
    @ingestions_data ||= begin
      range = 7.days.ago..Time.now
      current_user.ingestions.group_by_day(:time, range: range)
    end
  end
end
