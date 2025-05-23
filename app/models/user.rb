class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true
  validates :email_address, uniqueness: true

  validates :dni, uniqueness: true, allow_nil: true

  validates :dni, numericality: {
    only_integer: true,
    greater_than: 1_000_000,
    less_than: 100_000_000
  }, allow_nil: true

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
end
