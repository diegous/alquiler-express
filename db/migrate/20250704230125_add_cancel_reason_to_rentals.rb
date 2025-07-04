class AddCancelReasonToRentals < ActiveRecord::Migration[7.2]
  def change
    add_column :rentals, :cancel_reason, :text
  end
end
