class LivingProperty < Property
  validates :bedrooms, :guest_capacity, presence: true
  validates :bedrooms, :guest_capacity, numericality: {
    only_integer: true,
    greater_than: 0
  }
end
