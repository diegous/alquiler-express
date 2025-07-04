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

  def new
    property = Property.find(params[:property_id])
    @rental = property.rentals.new
  end

  def create
    @rental = Rental.new(rental_params)
    @rental.status = :accepted
    @rental.accepted_at = Time.current

    if @rental.save
      redirect_to admin_rental_path(@rental), flash: { success: "Reserva creada exitosamente" }
    else
      render :new
    end
  end

  def accept
    @rental = Rental.find(params[:id])
    @rental.accepted_at = Time.current
    @rental.accepted!

    CustomerMailer.with(rental: @rental).rental_accepted.deliver_now

    redirect_to admin_rental_path(@rental)
  rescue ActiveRecord::RecordInvalid
    message = "No se pudo aceptar la solicitud de reserva"

    if @rental.errors[:base].any?
      message << ": #{@rental.errors[:base].first}"
    end

    flash[:error] = message
    redirect_to admin_rental_path(@rental)
  end

  def cancel_form
    @rental = Rental.find(params[:id])
  end

  def cancel
    @rental = Rental.find(params[:id])
    @rental.cancel_reason = params[:reason]
    if @rental.cancelable?
      @rental.canceled!
    end

    CustomerMailer.with(rental: @rental).cancel_rental.deliver_now

    redirect_to admin_rental_path(@rental), notice: "Renta cancelada"
  end

  private

  def rental_params
    params.require(:rental).permit(:start, :end, :property_id, :owner_id)
  end

  # Hackish way of canceling rentals without a cron job
  def cancel_unpaid_rentals
    Rental.accepted
          .where("accepted_at < ?", Time.current - 24.hours)
          .each(&:canceled!)
  end
end
