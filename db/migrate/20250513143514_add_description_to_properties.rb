class AddDescriptionToProperties < ActiveRecord::Migration[7.2]
  def change
    add_column :properties, :description, :text
  end
end
