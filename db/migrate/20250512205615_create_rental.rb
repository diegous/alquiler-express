class CreateRental < ActiveRecord::Migration[7.1]
  def change
    create_table :rentals do |t|
      t.datetime :start
      t.datetime :end
      t.references :user, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true
      t.integer :status, default: 0
      t.float :total_cost, default: 0

      t.timestamps
    end
  end
end
