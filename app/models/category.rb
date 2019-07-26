class Category < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  validates :name, presence: true
end
