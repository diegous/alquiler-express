class AddEnabledToProperties < ActiveRecord::Migration[7.2]
  def change
    add_column :properties, :enabled, :boolean
  end
end
