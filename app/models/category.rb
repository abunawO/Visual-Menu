class Category < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
end
