class Admin < User
  has_secure_password

  def admin?
    true
  end
end
