class AddAltEmailGravatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :alt_email_gravatar, :string
  end
end
