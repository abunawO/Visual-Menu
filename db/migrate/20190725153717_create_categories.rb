class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :priority
      t.boolean :is_published
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
