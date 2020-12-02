class ApplicationController < ActionController::Base
    include SessionsHelper
    #current_userメソッドが使えるように
    # helperはコントローラーごとに作られる,そのコントローラー内ではincludeしなくても使える
end
