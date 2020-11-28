class UsersController < ApplicationController
  def index
  end

  def show
    @user = User.find(params[:id])
    #params[:id]は文字列型の"1"ですが、findメソッドでは自動的に整数型に変換されます。 
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    #マスアサインメントとは,フォームから送られてきたパラメーターをひとつにまとめて,一度に保存できるRailsの機能です。
    #例.@user = User.new(params[:user])@user = User.new(params[:user])
    if @user.save
      log_in @user #session_helperのメソッド
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      #=redirect_to user_url(@user) Railsが推察
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
