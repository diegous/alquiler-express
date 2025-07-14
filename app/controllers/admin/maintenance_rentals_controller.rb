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

  def cancel
    @rental = Rental.find(params[:id])
    @rental.cancel_reason = params[:reason]

    if @rental.cancellable?
      @rental.finished_maintenance!
      redirect_to admin_rental_path(@rental), flash: { success: "Mantenimiento Finalizado" }
    else
      redirect_to admin_rental_path(@rental), flash: { error: "Hubo un error" }
    end
  end

  private

  def maintenance_rental_params
    params.require(:rental).permit(:start, :end, :property_id, :owner_id)
  end
end
