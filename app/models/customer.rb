class Customer < User
  has_secure_password

  has_many :owned_rentals, class_name: Rental.name, foreign_key: "owner_id"

  enum :gender, { male: 1, female: 2, other: 3 }

  validates :gender, :last_name, :first_name, :phone, :dni, :dob,
            presence: true

  def customer?
    true
  end
end
