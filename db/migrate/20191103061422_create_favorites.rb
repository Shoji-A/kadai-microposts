class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :tweet, foreign_key: { to_table: :microposts }

      t.timestamps
      
      # ペア重複保存されないように
      t.index [:user_id, :tweet_id], unique: true
    end
  end
end
