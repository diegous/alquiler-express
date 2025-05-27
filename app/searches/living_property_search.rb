class LivingPropertySearch
  def filter(collection, params:)
    if params[:city].present?
      collection = collection.where("city like ?", "%#{params[:city].strip}%")
    end

    if params[:bedrooms].present?
      collection = collection.where(bedrooms: params[:bedrooms])
    end

    if params[:guest_capacity].present?
      collection = collection.where(guest_capacity: params[:guest_capacity])
    end

    if params[:living_property_type].present?
      collection = collection.where(living_property_type: params[:living_property_type])
    end

    collection
  end
end
