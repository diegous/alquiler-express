class LivingPropertiesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @properties = LivingProperty.all

    if params[:city].present?
      @properties = @properties.where("city like ?", "%#{params[:city].strip}%")
    end

    if params[:bedrooms].present?
      @properties = @properties.where(bedrooms: params[:bedrooms])
    end

    if params[:guest_capacity].present?
      @properties = @properties.where(guest_capacity: params[:guest_capacity])
    end

    if params[:living_property_type].present?
      @properties = @properties.where(living_property_type: params[:living_property_type])
    end
  end

  def show
    @property = LivingProperty.find(params[:id])
  end
end
