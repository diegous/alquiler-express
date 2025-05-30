class GuestsController < ApplicationController
  helper_method :rental
  before_action :authorize_owner, only: %i[new create]

  def find_by_dni
    @guest = rental.users.new(type: Guest)
  end

  def add_by_dni
    user = User.find_by(dni: guest_params[:dni])

    if user && user.dni.present?
      rental.users << user
      return redirect_to rental_path(rental), notice: "Huesped agregado"
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

    Guest.transaction do
      @guest.save!
      rental.users << @guest
      redirect_to rental_path(rental), notice: "Huesped agregado"
    rescue ActiveRecord::RecordInvalid
      render :new
    end
  end

  private

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
