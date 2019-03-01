class AddUbereatsLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ubereats_link, :string
  end
end
