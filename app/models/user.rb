class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true

  def admin?
    false
  end

  def employee?
    false
  end

  def customer?
    false
  end
end
