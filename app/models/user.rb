class User < ApplicationRecord
    #クラスに属性を追加、マグレーションファイルを編集していない為,仮想的な属性
    #has_secure_passwordメソッドでpassword属性は自動的に作られている
    attr_accessor :remember_token

    before_save { self.email = self.email.downcase }
    validates :name,  presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: true

    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
    #User.new　と同じ
    #クラスメソッド(self.メソッド名)を定義しているので,使うときは User.メソッド名
    # 渡された文字列のハッシュ値を返す
    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    #一般に、あるメソッドがオブジェクトのインスタンスを必要としていない場合は、クラスメソッドにするのが常道です
    # ランダムなトークンを返す
    def User.new_token
      SecureRandom.urlsafe_base64
    end

      # 永続セッションのためにユーザーをデータベースに記憶する
    def remember
      self.remember_token = User.new_token
      #1.remenber_token(passwordカラム)にランダムな値を渡す
      update_attribute(:remember_digest, User.digest(remember_token))
      #2.remenber_digest(password_digest)にハッシュ化(暗号)して保存
      #バリデーションを素通り,
    end

    # 渡されたトークンがダイジェストと一致したらtrueを返す
    def authenticated?(remember_token)
      return false if remember_digest.nil? #即座にメソッドを終了
      #bremenber_digestがnilのときbcryptライブラリ内部で例外が発生
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
      #User.authenticated?なので self.remember_digestでもいいがself省略
    end
    #BCrypt::Password.newはbcryptパスワードが作成などをするBCrypt::Passwordのクラスメソッドの一つ

    # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end