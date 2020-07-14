class AddActivationToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string, precision: 30
    add_column :users, :address, :string, precision: 255
    add_column :users, :phone_number, :string, precision: 11
  end
end
