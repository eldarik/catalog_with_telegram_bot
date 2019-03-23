class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :client, foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end
