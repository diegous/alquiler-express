class Payment < ApplicationRecord
  belongs_to :rental

  before_validation :sanitize_cc_number

  validates :card_owner, :card_cvc, :card_number, :card_exp_month, :card_exp_year, presence: true
  validates :card_owner, format: {
    with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+\z/,
    message: "solo puede contener letras y espacios"
  }
  validates :card_cvc, format: {
    with: /\A[0-9]{3}\z/,
    message: "deben ser 3 dígitos exactamente"
  }
  validates :card_number, format: {
    with: /\A[0-9]{16}\z/,
    message: "deben ser 16 dígitos exactamente"
  }
  validates :card_exp_month, numericality: {
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 12
  }
  validates :card_exp_year, numericality: {
    greater_than_or_equal_to: Date.current.year,
  }
  validate :valid_card_expiration
  validate :valid_card_number

  private

  def sanitize_cc_number
    self.card_number = self.card_number.try(:gsub, " ", "")
  end

  def valid_card_expiration
    return if card_exp_year.blank?
    return if card_exp_month.blank?
    return if card_exp_year > Date.current.year
    return if card_exp_month > Date.current.month

    errors.add(:card_exp_month, "tarjeta vencida")
  end

  def valid_card_number
    return if CreditCardChargeService.valid_card_number?(card_number)
    errors.add(:card_number, "numero inválido")
  end
end
