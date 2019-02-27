class AddMenuCategoriesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :menu_categories, :string
  end
end
