module Authorization
  extend ActiveSupport::Concern

  class_methods do
    def require_admin!(**options)
      before_action(**options) { render_forbidden unless Current.user&.admin? }
    end

    def require_employee!(**options)
      before_action(**options) { render_forbidden unless Current.user&.employee? }
    end
  end

  private

  def render_forbidden
    render plain: "403 Forbidden", status: 403
  end
end
