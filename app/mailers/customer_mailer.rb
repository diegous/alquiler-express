class CustomerMailer < ApplicationMailer
  def welcome_email
    @customer = params[:customer]
    mail(to: @customer.email_address, subject: "Bienvenido!")
  end
end
