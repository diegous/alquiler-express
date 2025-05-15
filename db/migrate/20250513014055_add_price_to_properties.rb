class AddPriceToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :price, :float
  end
end
