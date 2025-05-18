class Employee < User
  validates :last_name, :first_name, :phone, :dni, presence: true

  def employee?
    true
  end
end
