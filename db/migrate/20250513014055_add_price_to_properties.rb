class AddPriceToProperties < ActiveRecord::Migration[7.2]
  def change
    add_column :properties, :price, :float
  end
end
