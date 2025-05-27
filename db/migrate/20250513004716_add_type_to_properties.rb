class AddTypeToProperties < ActiveRecord::Migration[7.2]
  def change
    add_column :properties, :type, :string
  end
end
