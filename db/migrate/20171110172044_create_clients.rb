class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :telegram_uid

      t.timestamps
    end
    add_index :clients, :telegram_uid, unique: true
  end
end
