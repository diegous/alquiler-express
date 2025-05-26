class Guest < User
  self.table_name = :users

  validates :last_name, :first_name, :dni, :dob, presence: true
end
