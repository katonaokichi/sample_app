module SessionsHelper
    # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
    #sessionメソッド,一時保存のcookiesを作成,どこでも通用する
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログイン中のユーザーを返す(戻り値)（いる場合)
  # 記憶トークンcookieに対応するユーザーを返す
  def current_user  #sessionから確認しないと新しくログインしてもcookiesのユーザーになる
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
     # a = a + 1をa += 1で表す
     #||は項を左から順に判定し、trueになった時点で処理が終了
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user 
    #user == current_userだと存在しないuserでログインしてないときtrueとなってしまう
  end

  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user) #logoutにまとめる
    session.delete(:user_id) #sessionというハッシュのuser_idのキーを削除
    @current_user = nil
  end

  # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
    #ここで消さないとログインしない状態で保護されたページに行かない限りログインするたびに記憶したページに行く
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
    #if request.get?がないとpost,patceはredirectできないためエラーがおきる
  end
end
