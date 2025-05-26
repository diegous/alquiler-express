class CreateGuests < ActiveRecord::Migration[7.2]
  def change
    create_table :guests do |t|
      t.timestamps
    end
  end
end
