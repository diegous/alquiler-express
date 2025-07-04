class Rental < ApplicationRecord
  belongs_to :owner, class_name: User.name
  belongs_to :property
  has_and_belongs_to_many :users
  has_one :payment

  validates :owner_id, :property_id, :start, :end, :status, :total_cost, presence: true

  validate :no_colliding_rentals
  validate :valid_start_and_end, on: :create

  before_create :assign_total_cost

  enum :status, {
    dates_selected: 0,
    requested: 5,
    accepted: 10,
    paid: 20,
    started: 30,
    finished: 40,
    canceled: 100
  }

  def get_property
    self.property
  end

  def needs_guest?
    return false unless property.is_a?(LivingProperty)
    users.count < property.guest_capacity
  end

  def max_users_reached?
    users.count >= max_user_amount
  end

  def try_to_add_user(user)
    if max_users_reached?
      return {
        result: false,
        message: "Máxima cantidad de huéspedes alcanzada"
      }
    end

    guest_dnis = users.map(&:dni) + [ owner.dni ]
    if guest_dnis.include?(user.dni)
      return {
        result: false,
        message: "Ya hay un huesped con ese DNI"
      }
    end

    users << user

    {
      result: true,
      message: "Huesped agregado"
    }
  end

  def cancelable?
    dates_selected? || requested? || accepted? || paid? || started?
  end

  private

  def max_user_amount
    # The owner of the rental counts as 1 of the guests, so the upper
    # limit of guests is: property.guest_capacity - 1

    @max_user_amount ||= property.guest_capacity - 1
  end

  def assign_total_cost
    if property.is_a?(Garage)
      hours = (self.end - self.start) / 1.hour
      self.total_cost = property.price * hours
    else
      days = (self.end - self.start) / 1.day
      self.total_cost = property.price * days
    end
  end

  def no_colliding_rentals
    # This check should only be one if a reservation is created  (initial states
    # 'dates_selecte' and 'requestd) or when an employee accepts a request.
    return unless dates_selected? || requested? || accepted?

    rentals = property
      .rentals
      .where(status: %i[accepted paid started])
      .where.not(id: id)
      .where "end > :current_start AND start < :current_end",
             current_start: self.start,
             current_end: self.end

    if rentals.any?
      errors.add(:start, "Ya hay una reserva en esas fechas")
      errors.add(:end, "Ya hay una reserva en esas fechas")

      rental_start = rentals.first.start
      rental_end = rentals.first.end

      if !property.is_a?(Garage)
        rental_start = rental_start.to_date
        rental_end = rental_end.to_date
      end

      start_string = I18n.l(rental_start, format: :short)
      end_string = I18n.l(rental_end, format: :short)

      errors.add(:base, "Hay una reserva de #{start_string} al #{end_string}")
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
