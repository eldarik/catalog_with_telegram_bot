class AddPriceToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :price, :float, default: 0.0, null: false
  end
end
