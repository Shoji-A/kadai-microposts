class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      # 別テーブル参照
      t.references :user, foreign_key: true
      t.references :follow, foreign_key: { to_table: :users }

      t.timestamps
      
      # DB上で矛盾（重複保存）が起きないように
      t.index [:user_id, :follow_id], unique: true
    end
  end
end
