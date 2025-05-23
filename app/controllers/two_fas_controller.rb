class TwoFasController < ApplicationController
  allow_unauthenticated_access
  before_action :prevent_invalid_scenarios

  def new
  end

  def create
    elapsed_seconds = (Time.current - user.two_fa_timestamp) / 1.second

    if elapsed_seconds > 60
      token = rand(1000000).to_s
      user.update(two_fa_token: token, two_fa_timestamp: Time.current)
      AdminMailer.with(admin: user).two_fa_email.deliver_now

      redirect_to new_two_fa_path, alert: "Tardó demasiado, se envió otro token a su mail"
    elsif user.two_fa_token == params[:two_fa_token]
      user.update(two_fa_token: nil)
      redirect_to after_authentication_url
    else
      redirect_to new_two_fa_path, alert: "Token incorrecto"
    end
  end

  private

  def user
    @user ||= Current.user
  end

  def prevent_invalid_scenarios
    return head 500 unless user&.admin?
    return head 500 unless user.two_fa_token
    head 500 unless user.two_fa_timestamp
  end
end
