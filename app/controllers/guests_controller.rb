class GuestsController < ApplicationController
  helper_method :rental
  before_action :authorize_owner, only: %i[new create]

  def new
    @guest = rental.users.new(type: Guest)
  end

  def create
    dni = params[:guest][:dni]

    if dni.present? && new_guest = User.find_by(dni: dni)
      rental.users << new_guest
      return redirect_to rental_guests_path(rental)
    end

    @guest = Guest.new(guest_params)

    Guest.transaction do
      rental.users << @guest
      redirect_to rental_guests_path(rental)
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
