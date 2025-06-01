class Admin::RentalsController < ApplicationController
  require_employee!

  def index
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
end
