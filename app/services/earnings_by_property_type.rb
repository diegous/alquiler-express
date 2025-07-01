class EarningsByPropertyType < BaseReport

  private

  def data_for(property_class)
    rentals = rentals_for(property_class)

    rentals.pluck(:total_cost).sum
  end
end
