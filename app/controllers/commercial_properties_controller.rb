class CommercialPropertiesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @properties = CommercialPropertySearch.new.filter(CommercialProperty.where(enabled: true), params:)
  end

  def show
    @property = CommercialProperty.find(params[:id])
  end
end
