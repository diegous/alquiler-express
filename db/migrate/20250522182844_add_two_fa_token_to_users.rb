class AddTwoFaTokenToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :two_fa_token, :string
    add_column :users, :two_fa_timestamp, :datetime
  end
end
