class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user #メソッド呼び出しの時引数の()省略可能
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
      #フレンドリーフォワーディングするため
      #rails が　user_url(user)に変換
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
