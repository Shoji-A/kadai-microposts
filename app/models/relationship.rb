class Relationship < ApplicationRecord
  belongs_to :user
  # 補足設定　class_name: 'User'
  belongs_to :follow, class_name: 'User'
end
