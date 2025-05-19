class AddPriceToProperties < ActiveRecord::Migration[7.1]
  def change
    add_column :properties, :price, :float
  end
end
