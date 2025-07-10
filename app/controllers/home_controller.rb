class HomeController < ApplicationController
  allow_unauthenticated_access only: %i[ redirect_by_role ]

  def redirect_by_role
    if Current.user&.admin?
      redirect_to admin_living_properties_path
    else
      redirect_to living_properties_path
    end
  end
end
