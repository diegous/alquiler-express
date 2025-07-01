class BaseReport
  def call
    {
      LivingProperty => data_for(LivingProperty),
      CommercialProperty => data_for(CommercialProperty),
      Garage => data_for(Garage)
    }
  end

  private

  def rentals_for(property_class)
    Rental
      .joins(:property)
      .where(status: %i[paid started finished])
      .where(property: { type: property_class.name })
  end
end
