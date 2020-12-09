class MicropostsController < ApplicationController
before_action :logged_in_user, only: [:create, :destroy]
before_action :correct_user,   only: :destroy

def create
  @micropost = current_user.microposts.build(micropost_params)
  if @micropost.save
    flash[:success] = "Micropost created!"
    redirect_to root_url
  else
    @feed_items = current_user.feed.paginate(page: params[:page])
    render 'static_pages/home' #ファイル名
  end
end

def destroy
  @micropost.destroy
  flash[:success] = "Micropost deleted"
  redirect_to request.referrer || root_url
  #一つ前のURLを返す(destroyリクエストをしたページ)
end


  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    #URLからきたとき、投稿者か？(認可) & その投稿はデータベース上にあるのか？
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
  end