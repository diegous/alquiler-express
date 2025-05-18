class Customer < User
  enum :gender, { male: 1, female: 2, other: 3 }

  validates :gender, :last_name, :first_name, :phone, :dni, :dob,
            presence: true

  validates :dni, numericality: {
    only_integer: true,
    greater_than: 1_000_000,
    less_than: 100_000_000
  }

  def customer?
    true
  end
end
