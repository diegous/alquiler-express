class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_and_belongs_to_many :rentals

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
