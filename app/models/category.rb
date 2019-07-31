class Category < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  validates :name, presence: true

  before_save :update_priority



  private

    def update_priority
      self.priority = 0 if self.priority.eql?(nil)
    end
end
