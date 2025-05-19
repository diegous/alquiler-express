class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :dni, index: { unique: true }
      t.string :first_name
      t.string :last_name
      t.date :dob
      t.integer :gender
      t.string :phone

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
