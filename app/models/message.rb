class Message < ApplicationRecord
  belongs_to :user
  belongs_to :receive_user,class_name: "User"
  
  validates :content, presence: true,length: { maximum: 255 }
end
