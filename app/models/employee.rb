class Employee < User
  has_secure_password

  validates :last_name, :first_name, :phone, :dni, presence: true

  def employee?
    true
  end
end
