class AddTwoFaTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :two_fa_token, :string
    add_column :users, :two_fa_timestamp, :datetime
  end
end
