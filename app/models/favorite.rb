class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :tweet, class_name: 'Micropost'
end
