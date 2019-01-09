class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader #Adding an image to the Micropost model.
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 200 }
  validates :category,presence: true, length: { maximum: 50 }
  validates :price,   presence: true, numericality: true
  validates :description, presence: true, length: { maximum: 200 }

 #Adding validations to images.
  validate  :picture_size

  before_save :clean_content

  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

    def clean_content
      self.content = self.content.upcase.strip
      self.category = self.category.upcase.strip
      self.description = self.description.capitalize
    end
end
