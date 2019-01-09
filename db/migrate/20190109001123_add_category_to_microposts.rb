class AddCategoryToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :category, :string, :default => nil
  end
end
