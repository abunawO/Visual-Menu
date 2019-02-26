class AddDoordashLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :doordash_link, :string
  end
end
