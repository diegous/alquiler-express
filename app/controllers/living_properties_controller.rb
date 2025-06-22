class LivingPropertiesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @properties = LivingPropertySearch.new.filter(LivingProperty.where(enabled: true), params:)
  end

  def show
    @property = LivingProperty.find(params[:id])
  end
end
