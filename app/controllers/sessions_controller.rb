class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    #emailが正しくない時,userがnillになるのでuser.authenticateがエラーになってしまうので&&
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user #メソッド呼び出しの時引数の()省略可能
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        #違うPCからログインした時のために forget(user)
        redirect_back_or user
        #フレンドリーフォワーディングするため
        #rails がuser_url(user)に変換
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url #データを更新したプラウザを表示する
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      #flashは 現在のアクションと次のアクションまで表示されるので、1アクション無駄
      render 'new' #renderは借りるだけだからアクションじゃない
    end
  end

  def destroy
    log_out if logged_in? #curent_userがnilにならないように
    redirect_to root_url
  end
end
