class ReviewsController < ApplicationController
  def new
    property = Property.find(params[:property_id])
    @review = Review.new(user: Current.user, property: property)
  end

  def create
    property = Property.find(params[:property_id])
    @review = property.reviews.new(review_params)
    @review.user = Current.user

    if @review.save
      redirect_to property
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:message)
  end
end
