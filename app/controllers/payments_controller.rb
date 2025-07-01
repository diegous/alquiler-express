class PaymentsController < ApplicationController
  def new
    @rental = Current.user.owned_rentals.accepted.find(params[:rental_id])
    @payment = @rental.build_payment
  end

  def create
    @rental = Current.user.owned_rentals.accepted.find(params[:rental_id])
    @payment = @rental.build_payment(payment_params)

    return render :new if @payment.invalid?

    card_charge_result = CreditCardChargeService.new.call(@payment)

    if card_charge_result.success?
      Payment.transaction do
        @payment.save
        @rental.paid!
      end
      redirect_to @rental, flash: { success: "Reserva pagada exitosamente" }
    else
      @charge_error = card_charge_result.error
      render :new
    end
  end

  private

  def payment_params
    params.require(:payment).permit(
      :card_owner,
      :card_number,
      :card_exp_month,
      :card_exp_year,
      :card_cvc
    )
  end
end
