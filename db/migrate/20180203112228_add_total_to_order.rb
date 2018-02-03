class AddTotalToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :total, :float, default: 0.0, null: false
  end
end
