class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: %i[ new create ]
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])

    unless user&.authenticate(params[:password])
      return redirect_to new_session_path, alert: "Mail o contraseña incorrectos"
    end

    if user.disabled?
      return redirect_to new_session_path, alert: "Su usuario está desactivado"
    end

    start_new_session_for user

    if user.admin?
      token = rand(1000000).to_s
      user.update(two_fa_token: token, two_fa_timestamp: Time.current)
      AdminMailer.with(admin: user).two_fa_email.deliver_now
      redirect_to new_two_fa_path
    else
      redirect_to after_authentication_url
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
