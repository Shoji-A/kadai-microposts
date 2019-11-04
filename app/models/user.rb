class User < ApplicationRecord
  before_save { self.email.downcase! }
  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  # 暗号化
  has_secure_password
  
  # UserからMicropostをみたとき、複数存在するため
  has_many :microposts
  # 自分がフォローしているUserへの参照
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  # 自分をフォローしているUserへの参照
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  def follow(other_user)
    # 自分自身ではないか
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    # フォローがあればアンフォロー
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  #　タイムライン
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
end

