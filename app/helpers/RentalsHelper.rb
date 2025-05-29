module RentalsHelper
  def property_show_path(property)
    case property
    when LivingProperty
      living_property_path(property)
    when CommercialProperty
      commercial_property_path(property)
    # when Garage
    #  garage_path(property)
    else
      root_path # fallback
    end
  end
end
