class UserMailer < ApplicationMailer
#メール用のコントローラー
#アクションが,メソッドのように引数がある
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
    # mailメソッドに引数のtoキー,subjectキーを渡しmail objectを作成
    #return: mail object(text/html)
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end