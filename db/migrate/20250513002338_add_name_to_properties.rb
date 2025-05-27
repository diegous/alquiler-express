class AddNameToProperties < ActiveRecord::Migration[7.2]
  def change
    add_column :properties, :name, :string
  end
end
