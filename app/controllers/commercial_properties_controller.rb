class CommercialPropertiesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  require_admin! only: %i[ new create edit update ]

  def index
    @properties = CommercialProperty.all

    if params[:city].present?
      @properties = @properties.where("city like ?", "%#{params[:city].strip}%")
    end

    if params[:min_m2].present?
      min_m2 = params[:min_m2].to_f
      @properties = @properties.where("width * length >= ?", min_m2)
    end

    if params[:max_m2].present?
      max_m2 = params[:max_m2].to_f
      @properties = @properties.where("width * length <= ?", max_m2)
    end
  end

  def show
    @property = CommercialProperty.find(params[:id])
  end

  def new
    @property = CommercialProperty.new
  end

  def create
    @property = CommercialProperty.new(commercial_property_params)

    if @property.save
      redirect_to commercial_property_path(@property)
    else
      puts "Errores:"
      puts @property.errors.full_messages.join(", ")
      render :edit
    end
  end

  def edit
    @property = CommercialProperty.find(params[:id])
  end

  def update
    @property = CommercialProperty.find(params[:id])

    if @property.update(commercial_property_params)
      redirect_to commercial_property_path(@property)
    else
      render :edit
    end
  end

  private

  def commercial_property_params
    params.require(:commercial_property)
          .permit(:name, :price, :city, :length, :width, :description, pictures: [])
  end
end
