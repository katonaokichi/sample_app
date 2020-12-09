class CreateMicroposts < ActiveRecord::Migration[6.0]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      #user_idカラムの設定

      t.timestamps #created_atとupdated_atというカラムが追加
    end
    add_index :microposts, [:user_id, :created_at]
    #よく使うカラムの組み合わせを指定することにより高速化
    # indexにはunique: trueで一意性をデーターベース内で強制するサブ効果もある
  end
end
