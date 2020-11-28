module SessionsHelper
    # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
    #sessionメソッド,一時保存のcookiesを作成
  end

  def log_out
    session.delete(:user_id) #sessionというハッシュのuser_idのキーを削除
    @current_user = nil
  end

  # 現在ログイン中のユーザーを返す(戻り値)（いる場合）
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
      # a = a + 1をa += 1で表す
      #||は項を左から順に判定し、trueになった時点で処理が終了
    end
  end

  def logged_in?
    !current_user.nil?
  end

end
