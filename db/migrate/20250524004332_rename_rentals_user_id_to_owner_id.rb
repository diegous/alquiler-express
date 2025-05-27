class RenameRentalsUserIdToOwnerId < ActiveRecord::Migration[7.2]
  def change
    rename_column :rentals, :user_id, :owner_id
  end
end
