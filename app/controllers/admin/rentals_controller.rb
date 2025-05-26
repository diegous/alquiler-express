class Admin::RentalsController < ApplicationController
  require_employee!

  def index
    @rentals = Rental.all
  end

  def show
    @rental = Rental.find(params[:id])
  end
end
