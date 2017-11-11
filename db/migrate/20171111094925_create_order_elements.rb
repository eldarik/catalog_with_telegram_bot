class CreateOrderElements < ActiveRecord::Migration[5.0]
  def change
    create_table :order_elements do |t|
      t.references :order, foreign_key: true
      t.references :product, foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end
