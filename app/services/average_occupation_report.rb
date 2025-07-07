class AverageOccupationReport
  def call
    properties_by_guest_capacity = LivingProperty.all.each.with_object({}) do |object, hash|
      hash[object.guest_capacity] ||= []
      hash[object.guest_capacity].push(object.id)
    end

    properties_by_guest_capacity.map do |(guest_capacity, property_ids)|
      rentals = Rental.where(status: %i[paid started finished], property_id: property_ids)
      guests_count = rentals.map { |rental| rental.users.size + 1 }.sum
      max_occupation_possible = guest_capacity * rentals.size
      occupation_percentage = guests_count / max_occupation_possible.to_f * 100

      { guest_capacity:, occupation_percentage: }
    end
  end
end
