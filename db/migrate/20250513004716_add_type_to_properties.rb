class AddTypeToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :type, :string
  end
end
