class AddFirstNameLastNamePhoneNumberToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :first_name, :string
    add_column :clients, :last_name, :string
    add_column :clients, :phone_number, :string
  end
end
