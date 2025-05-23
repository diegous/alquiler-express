class LivingProperty < Property
  validates :bedrooms, :guest_capacity, :living_property_type, presence: true
  validates :bedrooms, :guest_capacity, numericality: {
    only_integer: true,
    greater_than: 0
  }

  enum :living_property_type, {
    house: 10,
    apartment: 20
  }
end
