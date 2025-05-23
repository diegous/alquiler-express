class AddLivingPropertyTaypeToProperty < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :living_property_type, :integer
  end
end
