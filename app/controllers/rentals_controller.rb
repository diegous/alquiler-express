class RentalsController < ApplicationController
  before_action :set_property, only: %i[new create]

  def index
    @rentals = Current.user.rentals
  end

  def new
    @rental = Rental.new
  end

  def create
    @rental = @property.rentals.new(living_property_rental_params)
    @rental.owner = Current.user

    if @rental.save
      redirect_to rental_guests_path(@rental)
    else
      render :new
    end
  end

  private

  def set_property
    @property ||= Property.find(params[:living_property_id])
  end

  def living_property_rental_params
    params.require(:rental).permit(:start, :end)
  end
end
