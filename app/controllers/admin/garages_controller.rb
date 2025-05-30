class Admin::GaragesController < ApplicationController
  require_admin!

  def index
    @garages = GarageSearch.new.filter(Garage.all, params: params)
  end

  def new
    @garage = Garage.new
  end

  def create
    @garage = Garage.new(garage_params)

    if @garage.save
      redirect_to garage_path(@garage), notice: "Cochera creada exitosamente"
    else
      render :new
    end
  end

  def edit
    @garage = Garage.find(params[:id])
  end

  def update
    @garage = Garage.find(params[:id])

    if @garage.update(garage_params)
      redirect_to garage_path(@garage), notice: "Cochera actualizada exitosamente"
    else
      render :edit
    end
  end

  private

  def garage_params
    params.require(:garage)
          .permit(
            :name,
            :width,
            :length,
            :price,
            :city,
            :pictures,
            :description
          )
  end
end
