class CustomerMailer < ApplicationMailer
  def welcome_email
    @customer = params[:customer]
    mail(to: @customer.email_address, subject: "Bienvenido!")
  end

  def rental_accepted
    @rental = params[:rental]
    mail(to: @rental.owner.email_address, subject: "Reserva aceptada")
  end

  def cancel_rental
    @rental = params[:rental]
    mail(to: @rental.owner.email_address, subject: "Cancelación de renta")
  end
end
