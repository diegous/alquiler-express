class Customer < User
  has_secure_password

  has_many :owned_rentals, class_name: Rental.name, foreign_key: "owner_id"

  validate :must_be_at_least_18_years_old

  enum :gender, { male: 1, female: 2, other: 3 }

  validates :gender, :last_name, :first_name, :phone, :dni, :dob,
            presence: true
  validate :must_be_at_least_18_years_old

  def customer?
    true
  end

  private

  def must_be_at_least_18_years_old
    return if dob.blank?

    if dob > 18.years.ago.to_date
      errors.add(:dob, "debe indicar una edad mínima de 18 años")
    end
  end
end
