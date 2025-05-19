class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
 allow_browser versions: :modern

  def redirect_if_logged_in
    if Current.user
      redirect_to root_path
    end
  end
end
