class Review < ApplicationRecord
  belongs_to :property
  belongs_to :user

  validates :message, presence: true
end
