class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_and_belongs_to_many :rentals

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true
  validates :email_address, uniqueness: true

  validates :dni, uniqueness: true, allow_nil: true
  validates :phone, allow_nil: true, format: { with: /\A\d{10}\z/, message: "deben ser 10 dígitos" }

  validates :dni, numericality: { only_integer: true }, allow_nil: true
  validate :dni_valid_range

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
end
