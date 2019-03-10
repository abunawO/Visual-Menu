class AddInstagramLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instagram_link, :string
  end
end
