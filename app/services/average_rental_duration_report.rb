class AverageRentalDurationReport
  def call
    {
      LivingProperty => data_for(LivingProperty, time_unit: :day),
      CommercialProperty => data_for(CommercialProperty, time_unit: :day),
      Garage => data_for(Garage, time_unit: :hour)
    }
  end

  private

  def data_for(property_class, time_unit:)
    rentals = rentals_for(property_class)
    amount = rentals.count
    total_duration = rentals.sum { |r| (r.end - r.start) / 1.send(time_unit) }

    average_duration = if amount == 0
      0
    else
      (total_duration / rentals.count)
    end

    {
      time_unit: time_unit,
      amount: amount,
      total_duration: total_duration,
      average_duration: average_duration
    }
  end

  def rentals_for(property_class)
    Rental
      .joins(:property)
      .where(status: %i[paid started finished canceled])
      .where(property: { type: property_class.name })
  end
end
