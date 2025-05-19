class AddDescriptionToProperties < ActiveRecord::Migration[7.1]
  def change
    add_column :properties, :description, :text
  end
end
