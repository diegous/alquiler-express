class CommercialPropertySearch
  def filter(collection, params:)
    if params[:city].present?
      collection = collection.where("city like ?", "%#{params[:city].strip}%")
    end

    if params[:min_m2].present?
      min_m2 = params[:min_m2].to_f
      collection = collection.where("width * length >= ?", min_m2)
    end

    if params[:max_m2].present?
      max_m2 = params[:max_m2].to_f
      collection = collection.where("width * length <= ?", max_m2)
    end

    collection
  end
end
