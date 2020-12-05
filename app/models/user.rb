class User < ApplicationRecord
    #クラスに属性を追加、マグレーションファイルを編集していない為,仮想的な属性
    #has_secure_passwordメソッドでpassword属性は自動的に作られている
    attr_accessor :remember_token, :activation_token
    # activation_token = と言うセッターメソッドと
    # (Userクラスのおぶジェクト).activation_token と言うゲッターメソッドが使える

    before_save   :downcase_email
    #オブジェクトがDBに保存される直前で実行
    before_create :create_activation_digest
    #オブジェクトがDBに新規保存される直前で実行されます

    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: true

    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    #User.newと同じ
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
    #user.authenticated?(:remember or "remenber", remember_token)
    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      #このコードはモデル内にあるのでselfは省略することもできます
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end
    #BCrypt::Password.newはbcryptパスワードが作成などをするBCrypt::Passwordのクラスメソッドの一つ

    # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private #Userモデル内でしか使わない

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end