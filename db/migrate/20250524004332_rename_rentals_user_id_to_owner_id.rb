class RenameRentalsUserIdToOwnerId < ActiveRecord::Migration[8.0]
  def change
    rename_column :rentals, :user_id, :owner_id
  end
end
