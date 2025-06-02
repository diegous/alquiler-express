class Admin::RentalsController < ApplicationController
  require_employee!

  def index
    cancel_unpaid_rentals

    @rentals = if params[:requested] == "true"
      Rental.requested
    else
      Rental.not_requested
    end
  end

  def show
    @rental = Rental.find(params[:id])
  end

  def accept
    @rental = Rental.find(params[:id])
    @rental.accepted_at = Time.current
    @rental.accepted!

    redirect_to admin_rental_path(@rental)
  rescue ActiveRecord::RecordInvalid
    message = "No se pudo aceptar la solicitud de reserva"

    if @rental.errors[:base].any?
      message << ": #{@rental.errors[:base].first}"
    end

    flash[:error] = message
    redirect_to admin_rental_path(@rental)
  end

  private

  # Hackish way of canceling rentals without a cron job
  def cancel_unpaid_rentals
    Rental.accepted
          .where("accepted_at < ?", Time.current - 24.hours)
          .each(&:canceled!)
  end
end
