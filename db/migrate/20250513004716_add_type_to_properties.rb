class AddTypeToProperties < ActiveRecord::Migration[7.1]
  def change
    add_column :properties, :type, :string
  end
end
