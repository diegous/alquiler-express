class LivingPropertiesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show edit update ]

  def show
    @property = LivingProperty.find(params[:id])
  end
end
