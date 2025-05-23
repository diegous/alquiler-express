class LivingPropertiesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  require_admin! only: %i[ new create edit update ]

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

  def new
    @property = LivingProperty.new
  end

  def create
    @property = LivingProperty.new(living_property_params)

    if @property.save
      redirect_to living_property_path(@property)
    else
      render :edit
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
