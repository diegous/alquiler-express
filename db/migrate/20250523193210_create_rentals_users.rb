class CreateRentalsUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :rentals_users do |t|
      t.references :rental, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
