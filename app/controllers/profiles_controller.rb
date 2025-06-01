class ProfilesController < ApplicationController
  before_action :require_login

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    if @user.update(profile_params)
      redirect_to root_path, notice: "Perfil actualizado correctamente"
    else
      render :edit
    end
  end

  private

  def require_profile_access
    unless Current.user.is_a?(Customer) || Current.user.is_a?(Employee)
      redirect_to root_path, alert: "No tiene permiso para acceder al perfil"
    end
  end

  def profile_params
    if Current.user.is_a?(Customer)
      params.require(:customer).permit(:first_name, :last_name, :phone, :dob, :gender)
    elsif Current.user.is_a?(Employee)
      params.require(:employee).permit(:first_name, :last_name, :phone)
    else
      {}
    end
  end
end
