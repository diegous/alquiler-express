class Admin::CommercialPropertiesController < ApplicationController
  require_admin! only: %i[ new create edit update ]

  def index
    @properties = CommercialPropertySearch.new.filter(CommercialProperty.all, params:)
  end

  def new
    @property = CommercialProperty.new
  end

  def create
    @property = CommercialProperty.new(commercial_property_params)

    if @property.save
      redirect_to commercial_property_path(@property), notice: "Local creado exitosamente"
    else
      render :new
    end
  end

  def edit
    @property = CommercialProperty.find(params[:id])
  end

  def update
    @property = CommercialProperty.find(params[:id])

    if @property.update(commercial_property_params)
      redirect_to commercial_property_path(@property), notice: "Local actualizado exitosamente"
    else
      render :edit
    end
  end

  def destroy
    @property = CommercialProperty.find(params[:id])
    if @property.has_active_rentals?
      redirect_to admin_commercial_properties_path, notice: "La propiedad #{@property.name} tiene reservas asociadas"
    else
      @property.update!(enabled: false)
      redirect_to admin_commercial_properties_path, notice: "Propiedad #{@property.name} desactivada"
    end
  end

  def enable
    @property = CommercialProperty.find(params[:id])
    @property.update!(enabled: true)
    redirect_to admin_commercial_properties_path, notice: "Propiedad #{@property.name} activada"
  end

  private

  def commercial_property_params
    params.require(:commercial_property)
          .permit(:name, :price, :city, :length, :width, :description, :pictures)
  end
end
