class Property < ApplicationRecord
  validates :name, :city, :price, :description, presence: true
  validates :price, numericality: { greater_than: 0 }

  has_many_attached :pictures
end
