class AddLivingPropertyTaypeToProperty < ActiveRecord::Migration[7.2]
  def change
    add_column :properties, :living_property_type, :integer
  end
end
