class Rental < ApplicationRecord
  belongs_to :owner, class_name: User.name
  belongs_to :property
  has_and_belongs_to_many :users
  has_one :payment
  belongs_to :cancelled_by_employee, class_name: User.name, optional: true

  validates :owner_id, :property_id, :start, :end, :status, :total_cost, presence: true

  validate :no_colliding_rentals
  validate :valid_start_and_end, on: :create
  validate :no_other_rentals_for_owner, on: :create
  validate :valid_duration, on: :create

  before_create :assign_total_cost

  enum :status, {
    dates_selected: 0,
    requested: 5,
    accepted: 10,
    paid: 20,
    started: 30,
    finished: 40,
    canceled: 100,
    maintenance: 120,
    finished_maintenance: 140
  }

  def get_property
    self.property
  end

  def must_have_guests?
    return false if maintenance_related?
    property.must_have_guests?
  end

  def needs_guest?
    return false unless property.is_a?(LivingProperty)
    return false if maintenance_related?
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

  def cancellable?
    dates_selected? || requested? || accepted? || paid? || started? || maintenance?
  end

  def maintenance_related?
    maintenance? || finished_maintenance?
  end

  private

  def max_user_amount
    # The owner of the rental counts as 1 of the guests, so the upper
    # limit of guests is: property.guest_capacity - 1

    @max_user_amount ||= property.guest_capacity - 1
  end

  def assign_total_cost
    return 0 if maintenance?

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
    # 'dates_selecte' and 'requestd), when an employee accepts a request, or
    # when a maintenance rental is created.
    return unless dates_selected? || requested? || accepted? || maintenance?

    rentals = property
      .rentals
      .where(status: %i[accepted paid started maintenance])
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

  def no_other_rentals_for_owner
    return if owner.blank?
    return if owner.employee?

    colliding_rentals = owner
      .owned_rentals
      .where(status: %i[dates_selected requested accepted paid started])
      .where(property_id: Property.where(type: property.type))
      .where("end > :current_start AND start < :current_end",
             current_start: self.start,
             current_end: self.end)

    return unless colliding_rentals.exists?

    rental_start = self.start
    rental_end = self.end

    if !property.is_a?(Garage)
      rental_start = rental_start.to_date
      rental_end = rental_end.to_date
    end

    start_string = I18n.l(rental_start, format: :short)
    end_string = I18n.l(rental_end, format: :short)
    property_type = I18n.t(Property.last.class.name)

    errors.add(:base, "Ya tiene una reserva de #{property_type} hecha entre #{start_string} y #{end_string}")
  end

  def valid_duration
    # A rental cannot last more than 30 days
    return if self.start.blank?
    return if self.end.blank?
    return if (self.end - self.start) / 1.day <= 30
    errors.add(:end, "no puede durar más de 30 días")
  end
end
