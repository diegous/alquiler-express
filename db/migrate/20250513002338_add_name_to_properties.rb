class AddNameToProperties < ActiveRecord::Migration[7.1]
  def change
    add_column :properties, :name, :string
  end
end
