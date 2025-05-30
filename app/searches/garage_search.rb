class GarageSearch
  def filter(collection, params:)
    if params[:city].present?
      collection = collection.where("city like ?", "%#{params[:city].strip}%")
    end

    if params[:min_width].present?
      collection = collection.where(width: params[:min_width]..)
    end

    if params[:min_length].present?
      collection = collection.where(length: params[:min_length]..)
    end

    collection
  end
end
