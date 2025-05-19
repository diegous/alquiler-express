class Rental < ApplicationRecord
  validates :email_address, presence: true

  before_create :assign_total_cost

  enum :status, {
    requested: 0,
    accepted: 10,
    paid: 20,
    started: 30,
    finished: 40,
    canceled: 100
  }

  private

  def assign_total_cost
    if property.is_a?(Garage)
      hours = (self.end - self.start) / 1.hour
      total_cost = property.price * hours
    else
      days = (self.end - self.start) / 1.day
      total_cost = property.price * days
    end
  end
end
