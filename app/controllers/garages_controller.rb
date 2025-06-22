class GaragesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @garages = GarageSearch.new.filter(Garage.where(enabled: true), params: params)
  end

  def show
    @garage = Garage.find(params[:id])
  end
end
