class RentalMailer < ApplicationMailer
  def cancel_rental
    @rental = params[:rental]
    @reason = params[:reason]
    mail(to: @rental.owner.email_address, subject: "Cancelación de renta")
  end
end
