class ApplicationController < ActionController::Base
    def hello
        render html: "できてまっか"
    end
end
