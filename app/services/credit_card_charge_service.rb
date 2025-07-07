class CreditCardChargeService
  include ReturnObject

  INSUFFICIENT_FUNDS = "1111111111111111"
  BLOQUED = "2222222222222222"
  PROCESSING_ERROR = "3333333333333333"
  SUCCESSFUL_PAYMENT = "4444444444444444"

  VALID_CARDS = [ INSUFFICIENT_FUNDS, BLOQUED, PROCESSING_ERROR, SUCCESSFUL_PAYMENT ]

  def self.valid_card_number?(card_number)
    VALID_CARDS.include? card_number
  end

  def call(payment)
    return false unless payment.valid?
    return return_errors("CVC inválido") unless payment.card_cvc == "123"

    case payment.card_number
    when INSUFFICIENT_FUNDS then return_errors("saldo insuficiente")
    when BLOQUED then return_errors("la tarjeta se encuentra bloqueada")
    when PROCESSING_ERROR then return_errors("error al procesar el pago")
    when SUCCESSFUL_PAYMENT then return_object(true, messgae: "pago exitoso")
    else return_errors("número de tarjeta inválido")
    end
  end
end
