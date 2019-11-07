class Micropost < ApplicationRecord
  # 一対多の表現
  belongs_to :user
  
  # バリデーション（検証）
  validates :content, presence: true, length: { maximum: 255 }
  
  # 自分のmicropostをお気に入りしているUserを参照
  has_many :favorites
  has_many :collectors, through: :favorites, source: :user
  
end
