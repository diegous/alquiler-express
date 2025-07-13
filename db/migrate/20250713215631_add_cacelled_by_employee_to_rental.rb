class AddCacelledByEmployeeToRental < ActiveRecord::Migration[7.2]
  def change
    add_reference :rentals, :cancelled_by_employee, foreign_key: { to_table: :users }
  end
end
