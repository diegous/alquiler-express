module Authorization
  extend ActiveSupport::Concern

  class_methods do
    def require_admin!(**options)
      before_action :authorize_admin, **options
    end

    def require_employee!(**options)
      before_action(**options) { render_forbidden unless Current.user&.employee? }
    end
  end

  private

  def authorize_admin
    render_forbidden unless Current.user&.admin?

    # The 2fa token is set when the admin attempts to login, and its cleard
    # when the 2fa step is completed. Meanwhile, they shouln't be able to
    # view the admin-side of the website.
    redirect_to new_two_fa_path if Current.user&.two_fa_token
  end

  def render_forbidden
    render plain: "403 Forbidden", status: 403
  end
end
