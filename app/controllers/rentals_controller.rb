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
    @rental = @property.rentals.new(living_property_rental_params)
    @rental.owner = Current.user
    @rental.status = :dates_selected

    if @rental.save
      redirect_to rental_path(@rental)
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
