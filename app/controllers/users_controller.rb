class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  #選択したアクションの前に合体する,onlyはオプション
  
  def index
    #url?伝えたい内容によってparams[:page]をつたえる
    #will_paginateによってURLは自動的に生成される
    @users = User.paginate(page: params[:page])
    #User.paginate(page:ページ数)で30人ずつのデータを取り出す
    #will_paginateのため
  end

  def show
    @user = User.find(params[:id])
    #params[:id]は文字列型の"1"ですが、findメソッドでは自動的に整数型に変換されます。 
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    #マスアサインメントとは,フォームから送られてきたパラメーターをひとつにまとめて,一度に保存できるRailsの機能です。
    # params[:user]={id:1,name:"kato"..}とハッシュインハッシュ
    #例.@user = User.new(params[:user])
    if @user.save
      @user.send_activation_email
      #UserMailerのaccount_activationメソッドを使って作った
      #mailオブジェトに対してdeliver_nowメソッドを使って送信する
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url #redirect_toはURLが必要
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    #URLを直で発行された時の対策
    # 編集者が自分であるか
    def correct_user
      @user=User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
     # 管理者かどうか確認
     def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
