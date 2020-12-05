require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    #Action Mailerから送信されたメールの配列を保持します
    #配列の中を削除
  end

  test "invalid signup information" do
    get signup_path #getメソッドを使ってユーザー登録ページにアクセス
    assert_no_difference 'User.count' do #railsのカスタムアサーション,メソッド
      #users_pathに対してPOSTリクエストを送信する
      post users_path, params: { user: {
      name:  "",
      email: "user@invalid",
      password:              "foo",
      password_confirmation: "bar" } }
    end
    assert_template 'users/new' #正しい見た目になっているのか？
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { 
        name:  "Example User",
        email: "user@example.com", 
        password: "password",
        password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size

    user = assigns(:user)
    #現在いるアプリケーションコード(コントローラー)のインスタンス変数@userにアクセスできる
    #assings(:usser)==@user (createコントローラーの定義された瞬間の)
    assert_not user.activated?
    # 有効化していない状態でログインしてみる
    log_in_as(user) #テストヘルパーメソッド
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
