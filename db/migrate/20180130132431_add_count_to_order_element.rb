class AddCountToOrderElement < ActiveRecord::Migration[5.0]
  def change
    add_column :order_elements, :count, :integer, null: false
  end
end
