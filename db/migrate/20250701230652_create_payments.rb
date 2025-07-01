class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :rental, null: false, foreign_key: true
      t.string :card_owner
      t.string :card_number, limit: 16
      t.string :card_cvc, limit: 3
      t.integer :card_exp_month
      t.integer :card_exp_year

      t.timestamps
    end
  end
end
