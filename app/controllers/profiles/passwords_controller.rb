class Profiles::PasswordsController < ApplicationController
  before_action :require_login

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    if @user.update(profile_params)
      redirect_to profile_path(@user), notice: "Contraseña actualizada correctamente"
    else
      render :edit
    end
  end

  private

  def profile_params
    user_type = Current.user.customer? ? :customer : :employee
    params.require(user_type).permit(:password, :password_confirmation)
  end
end
