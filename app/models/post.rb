class Post < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true,length: { maximum: 255 }
  
  mount_uploader :image, ImageUploader
  
  has_many :comments
  has_many :favorites
  has_many :fav_users,through: :favorites,source: :user
end
