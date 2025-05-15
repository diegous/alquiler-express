class LivingPropertiesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show edit update ]

  def show
    @property = LivingProperty.find(params[:id])
  end

  def edit
    @property = LivingProperty.find(params[:id])
  end

  def update
    @property = LivingProperty.find(params[:id])

    if @property.update(living_property_params)
      redirect_to living_property_path(@property)
    else
      render :edit
    end
  end

  private

  def living_property_params
    params.require(:living_property)
          .permit(:name, :bedrooms, :guest_capacity, :price, :city, :pictures, :description)
  end
end
