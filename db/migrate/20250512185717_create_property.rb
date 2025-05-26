class CreateProperty < ActiveRecord::Migration[7.2]
  def change
    create_table :properties do |t|
      t.integer :bedrooms
      t.integer :guest_capacity
      t.string :city
      t.float :width
      t.float :length
      t.float :surface

      t.timestamps
    end
  end
end
