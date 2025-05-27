class Admin::LivingPropertiesController < ApplicationController
  require_admin!

  def index
    @properties = LivingPropertySearch.new.filter(LivingProperty.all, params:)
  end

  def new
    @property = LivingProperty.new
  end

  def create
    @property = LivingProperty.new(living_property_params)

    if @property.save
      redirect_to living_property_path(@property)
    else
      render :new
    end
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
          .permit(
            :name,
            :living_property_type,
            :bedrooms,
            :guest_capacity,
            :price,
            :city,
            :pictures,
            :description
          )
  end
end
