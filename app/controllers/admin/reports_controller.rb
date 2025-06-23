class Admin::ReportsController < ApplicationController
  require_admin!

  def index
  end

  def average_duration

    @report_data = AverageRentalDurationReport.new.call
  end
end
