class Garage < Property
  validates :width, :length, :description, presence: true
end
