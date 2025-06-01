class ApplicationController < ActionController::Base
  include Authentication
  include Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def redirect_if_logged_in
    if Current.user
      redirect_to root_path
    end
  end

  def require_login
    unless Current.user
      redirect_to new_session_path, alert: "Debes iniciar sesión"
    end
  end
end
