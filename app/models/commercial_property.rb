class CommercialProperty < Property
validates :width, :length, presence: {
  message: "es obligatorio"
}
validates :width, :length, numericality: {
  greater_than_or_equal_to: 1,
  less_than_or_equal_to: 100,
  message: "debe estar entre 1 y 100 metros"
}
end
