class Admin::MaintenanceRentalsController < ApplicationController
  require_employee!

  def new
    property = Property.find(params[:property_id])
    @rental = property.rentals.new
  end

  def create
    @rental = Rental.new(maintenance_rental_params)
    @rental.status = :maintenance

    if @rental.save
      redirect_to admin_rental_path(@rental), flash: { success: "Período de mantenimiento creado exitosamente" }
    else
      render :new
    end
  end

  def destroy
    @rental = Rental.find(params[:id])
    @rental.cancel_reason = params[:reason]
    if @rental.cancelable?
      @rental.canceled!
    end

    CustomerMailer.with(rental: @rental).cancel_rental.deliver_now

    redirect_to admin_rental_path(@rental), notice: "Renta cancelada"
  end

  private

  def maintenance_rental_params
    params.require(:rental).permit(:start, :end, :property_id, :owner_id)
  end
end
