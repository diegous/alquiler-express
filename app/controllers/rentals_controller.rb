class RentalsController < ApplicationController
  before_action :set_property, only: %i[new create]

  def index
    @rentals = Current.user.owned_rentals
  end

  def show
    @rental = Current.user.owned_rentals.find(params[:id])
  end

  def new
    @rental = @property.rentals.new
    @rental.owner = Current.user
  end

  def create
    @rental = @property.rentals.new(property_rental_params)
    @rental.owner = Current.user
    @rental.status = :requested unless @property.is_a?(LivingProperty)

    if @rental.save
      redirect_to rental_path(@rental)
    else
      render :new
    end
  end

  def send_request
    @rental = Current.user.owned_rentals.find(params[:id])
    if @rental.owner == Current.user
      @rental.requested!
      redirect_to rental_path(@rental), notice: "Solicitud enviada"
    else
      redirect_to rental_path(@rental), notice: "No es el solicitante"
    end
  end

  def cancel
    @rental = Current.user.owned_rentals.find(params[:id])

    if @rental.cancellable?
      @rental.canceled!
      redirect_to rental_path(@rental), notice: "Reserva cancelada"
    else
      redirect_to rental_path(@rental), flash: { error: "La reserva no es cancelable" }
    end
  end

  private
  def set_property
      @property ||= Property.find(params[:property_id])
  end

  def property_rental_params
    params.require(:rental).permit(:start, :end)
  end
end
