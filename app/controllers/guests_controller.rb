class GuestsController < ApplicationController
  helper_method :rental
  before_action :authorize_owner, only: %i[new create]
  before_action :check_max_guests

  def find_by_dni
    @guest = rental.users.new(type: Guest)
  end

  def add_by_dni
    user = User.find_by(dni: guest_params[:dni])

    if user && user.dni.present?
      result = rental.try_to_add_user(user)
      flash_type = result[:result] ? :notice : :error
      flash[flash_type] = result[:message]
      return redirect_to rental_path(rental)
    end

    @guest = rental.users.new(type: Guest, dni: guest_params[:dni])
    @guest.valid?

    if @guest.errors[:dni].any?
      render :find_by_dni
    else
      redirect_to new_rental_guest_path(dni: @guest.dni)
    end
  end

  def new
    @guest = rental.users.new(type: Guest, dni: params[:dni])
  end

  def create
    @guest = Guest.new(guest_params)
    result = {}

    Guest.transaction do
      @guest.save!
      result = rental.try_to_add_user(@guest)

      if !result[:result]
        raise ActiveRecord::Rollback
      end
    end

    if result[:result]
      flash[:success] = result[:message]
      redirect_to rental_path(rental)
    else
      flash[:error] = result[:message]
      render :new
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  private

  def check_max_guests
    if rental.max_users_reached?
      flash[:error] = "Máxima cantidad de huéspedes alcanzada"
      redirect_to rental_path(rental)
    end
  end

  def authorize_owner
    return if Current.user == rental.owner
    render_forbidden
  end

  def rental
    @rental ||= Rental.find(params[:rental_id])
  end

  def guest_params
    params.require(:guest).permit(
      :email_address,
      :first_name,
      :last_name,
      :dni,
      :dob
    )
  end
end
