class AddAcceptedAtToRental < ActiveRecord::Migration[7.2]
  def change
    add_column :rentals, :accepted_at, :timestamp
  end
end
