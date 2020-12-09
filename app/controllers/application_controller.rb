class ApplicationController < ActionController::Base
  include SessionsHelper
  #current_userメソッドが使えるように
  # helperはコントローラーごとに作られる,そのコントローラー内ではincludeしなくても使える
  
  private
    #一般化
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
      end
    end
end
