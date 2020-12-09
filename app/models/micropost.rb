class Micropost < ApplicationRecord
  belongs_to :user #ユーザーと１対１の関係であることを表す
  has_one_attached :image #マイクロポスト1件につき画像は1件(imageは独自)
  default_scope -> { order(created_at: :desc) }
  #ラムダ式(->)はブロックを引数に取りProcオブジェクトを返す
  #Procオブジェクトはオブジェクト名.callで呼び出せる
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,
  content_type: { in: %w[image/jpeg image/gif image/png],
    message: "must be a valid image format" },
  size: { less_than: 5.megabytes,
    message: "should be less than 5MB" }

  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [500, 500])
    #variant(変換済み) Active Storageが提供
  end
end
