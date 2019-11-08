class User < ApplicationRecord
  before_save { self.email.downcase! }
  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  # 暗号化
  has_secure_password
  
  # 一対多
  has_many :microposts
  # 自分がフォローしているUserへの参照
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  # 自分をフォローしているUserへの参照
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  # 自分がお気に入りしているmicropost
  has_many :favorites, dependent: :destroy
  has_many :tweets, through: :favorites, source: :micropost
  
  # 自分自身ではないか
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  # アンフォロー機能
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  # フォローしているか
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  # タイムライン
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  # お気に入りにする
  def like(other_micropost)
    self.favorites.find_or_create_by(micropost_id: other_micropost.id)
  end
  
  # お気に入り解除
  def unlike(other_micropost)
    favorite = self.favorites.find_by(micropost_id: other_micropost.id)
    favorite.destroy if favorite
  end
  
  # お気に入りにしているか
  def tweet?(other_micropost)
    self.tweets.include?(other_micropost)
  end
end
