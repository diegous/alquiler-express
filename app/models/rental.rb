class Rental < ApplicationRecord
  belongs_to :owner, class_name: User.name
  belongs_to :property
  has_and_belongs_to_many :users

  validates :owner, :property, :start, :end, :status, :total_cost, presence: true

  validate :valid_user_amount
  validate :no_colliding_rentals
  validate :valid_start_and_end

  before_create :assign_total_cost

  enum :status, {
    draft: 0,
    requested: 5,
    accepted: 10,
    paid: 20,
    started: 30,
    finished: 40,
    canceled: 100
  }

  private

  def assign_total_cost
    # if property.is_a?(Garage)
    #   hours = (self.end - self.start) / 1.hour
    #   total_cost = property.price * hours
    # else
    days = (self.end - self.start) / 1.day
    total_cost = property.price * days
    # end
  end

  def no_colliding_rentals
    rentals = property
      .rentals
      .where(status: %i[accepted paid started])
      .where "end > :current_start AND start < :current_end",
             current_start: self.start,
             current_end: self.end

    if rentals.any?
      errors.add(:start, "Ya hay una reserva en esas fechas")
      errors.add(:end, "Ya hay una reserva en esas fechas")
    end
  end

  def valid_user_amount
    return if self.draft?

    if users.none?
      errors.add(:base, "Debe haber al menos un inquilino")
    elsif user.count > property.guest_capacity
      errors.add(:base, "Debe haber un máximo de #{property.guest_capacity} inquilinos")
    end
  end

  def valid_start_and_end
    return if self.start.blank?
    return if self.end.blank?

    if self.start >= self.end
      errors.add(:end, "debe ser posterior al checkin")
    end

    if self.start <= Time.current
      errors.add(:start, "debe ser posterior a hoy")
    end
  end
end
