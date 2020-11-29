class ApplicationController < ActionController::Base
    include SessionsHelper
    #@current_userが使えるように
    # helperはコントローラーごとに作られる,そのコントローラー内ではincludeしなくても使える
end
