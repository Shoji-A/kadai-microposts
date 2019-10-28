class Micropost < ApplicationRecord
  # 一対多の表現
  belongs_to :user
  
  # バリデーション（検証）
  validates :content, presence: true, length: { maximum: 255 }
end
