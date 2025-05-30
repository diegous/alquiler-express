class RegistrationsController < ApplicationController
  before_action :redirect_if_logged_in
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new

    if @customer.update(customer_params)
      CustomerMailer.with(customer: @customer).welcome_email.deliver_now
      redirect_to root_path, notice: "Cuenta creada exitosamente"
    else
      render :new
    end
  end

  private

  def customer_params
    params.require(:customer).permit(
      :last_name,
      :first_name,
      :phone,
      :dni,
      :dob,
      :gender,
      :email_address,
      :password,
      :password_confirmation
    )
  end
end
