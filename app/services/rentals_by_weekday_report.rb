class RentalsByWeekdayReport < BaseReport
  private

  def data_for(property_class)
    weekdays = Array.new(7, 0)
    rentals = rentals_for(property_class)

    rentals.each do |rental|
      (rental.start.to_date .. rental.end.to_date).map do |date|
        weekdays[date.wday] += 1
      end
    end

    {
      rentals_amount: rentals.count,
      rentals_weekday_data: weekdays
    }
  end
end
