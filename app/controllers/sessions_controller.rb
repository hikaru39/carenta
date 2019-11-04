class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
    else
      flash.alert = "メールアドレスとパスワードが一致しません"
    end
    redirect_to :root
  end
  
  def destroy
    session.delete(:user_id)
    redirect_to :root
  end
end
