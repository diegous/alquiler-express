class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :review, dependent: :destroy
  has_and_belongs_to_many :rentals

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true
  validates :email_address, uniqueness: true

  validates :dni, uniqueness: true, allow_nil: true
  validates :phone, allow_nil: true, format: { with: /\A\d{10}\z/, message: "deben ser 10 dígitos" }

  validates :dni, numericality: { only_integer: true }, allow_nil: true
  validate :dni_valid_range

  validate :must_be_at_least_18_years_old

  validates :first_name, format: { with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+\z/, message: "solo puede contener letras y espacios" }, allow_nil: true
  validates :last_name,  format: { with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+\z/, message: "solo puede contener letras y espacios" }, allow_nil: true

  generates_token_for :password_reset, expires_in: 1.hour

  def password_reset_token
    generate_token_for(:password_reset)
  end

  def admin?
    false
  end

  def employee?
    false
  end

  def customer?
    false
  end

  def disabled?
    !enabled?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def dni_valid_range
    return if dni.blank?

    integer_dni = Integer(dni)

    if integer_dni > 100_000_000
      errors.add(:dni, "debe ser menor a 100 millones")
    end

    if integer_dni < 1_000_000
      errors.add(:dni, "debe ser mayor a 1 millón")
    end
  rescue ArgumentError
    errors.add(:dni, "no es un número válido")
  end


  def must_be_at_least_18_years_old
    return if dob.blank?

    if dob > 18.years.ago.to_date
      errors.add(:dob, "debe indicar una edad mínima de 18 años")
    end
  end
end
