class Micropost < ApplicationRecord
  belongs_to :user #ユーザーと１対１の関係であることを表す
  default_scope -> { order(created_at: :desc) }
  #ラムダ式(->)はブロックを引数に取りProcオブジェクトを返す
  #Procオブジェクトはオブジェクト名.callで呼び出せる
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
