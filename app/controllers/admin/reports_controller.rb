class Admin::ReportsController < ApplicationController
  require_admin!

  def index
  end

  def average_duration
    @report_data = AverageRentalDurationReport.new.call
  end

  def rentals_by_weekday
    @report_data = RentalsByWeekdayReport.new.call
  end
end
