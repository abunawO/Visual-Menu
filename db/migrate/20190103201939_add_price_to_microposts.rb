class AddPriceToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :price, :float
  end
end
