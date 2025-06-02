class Property < ApplicationRecord
  has_many :rentals
  has_many :reviews, dependent: :destroy

  validates :name, :city, :price, :description, presence: true
  validates :price, numericality: { greater_than: 0 }

  has_many_attached :pictures
  validate :must_have_a_picture

  validates :name,  format: { with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+\z/, message: "solo puede contener letras y espacios" }

  validates :city, format: { with: /\A[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s]+\z/, message: "solo puede contener letras, números y espacios" }, allow_nil: true

  def must_have_guests?
    false
  end

  private

  def must_have_a_picture
    if pictures.blank?
      errors.add(:pictures, "debe tener una imagen")
    end
  end
end
