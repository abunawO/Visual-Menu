class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :address_line2, :string
    add_column :users, :address_line1, :string
    add_column :users, :city, :string
    add_column :users, :region, :string
    add_column :users, :postal_code, :string
    add_column :users, :country, :string
  end
end
