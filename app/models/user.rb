class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length: { maximum: 10 }
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false}
    validates :introduce, length: { maximum: 255 } 
    validates :password,presence: true,length: { minimum: 6 }, on: :create 
    mount_uploader :image, ImageUploader
    has_secure_password
    
    has_many :posts
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverse_relationship, class_name: "Relationship",foreign_key: "follow_id"
    has_many :followers, through: :reverse_relationship, source: :user
    has_many :comments
    
    has_many :favorites
    has_many :fav_posts, through: :favorites, source: :post
    
    has_many :messages
    has_many :sent_messages,through: :messages, source: :receive_user
    has_many :reverses_of_message,class_name:"Message",foreign_key: "receive_user_id"
    has_many :received_messages, through: :reverses_of_message, source: :user
    
    scope :get_by_name, ->(name) {where("name like ?", "%#{name}%")}
    
    def follow(other_user)
      unless self == other_user
        self.relationships.find_or_create_by(follow_id: other_user.id)
      end
    end 
    
    def unfollow(other_user)
       relationship = self.relationships.find_by(follow_id: other_user.id) 
       relationship.destroy if relationship
    end
    
    def follow?(other_user)
       self.followings.include?(other_user) 
    end
    
    def like(post)
      self.favorites.find_or_create_by(post_id: post.id)  
    end
    
    def unlike(post)
       favorite = Favorite.find_by(user_id: self.id,post_id: post.id)
       favorite.destroy if favorite
    end
    
    def like?(post)
        self.fav_posts.include?(post)
    end
    
    def feed_posts
        Post.where(user_id: self.following_ids + [self.id])
    end
end
