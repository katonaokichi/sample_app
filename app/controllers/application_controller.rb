class ApplicationController < ActionController::Base
    include SessionsHelper
    # helperはコントローラーごとに作られる,そのコントローラー内ではincludeしなくても使える
end
