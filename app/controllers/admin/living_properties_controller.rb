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
      redirect_to living_property_path(@property), notice: "Vivienda creada exitosamente"
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
      redirect_to living_property_path(@property), notice: "Vivienda actualizada exitosamente"
    else
      render :edit
    end
  end

  def destroy
    @property = LivingProperty.find(params[:id])
    if @property.has_active_rentals?
      redirect_to admin_living_properties_path, notice: "La propiedad #{@property.name} tiene reservas asociadas"
    else
      @property.update!(enabled: false)
      redirect_to admin_living_properties_path, notice: "Propiedad #{@property.name} desactivada"
    end
  end

  def enable
    @property = LivingProperty.find(params[:id])
    @property.update!(enabled: true)
    redirect_to admin_living_properties_path, notice: "Propiedad #{@property.name} activada"
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
