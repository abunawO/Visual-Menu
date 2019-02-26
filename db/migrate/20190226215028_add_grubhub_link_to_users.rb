class AddGrubhubLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :grubhub_link, :string
  end
end
