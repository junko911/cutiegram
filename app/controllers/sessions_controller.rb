class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:session][:username])

    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to user
    else
      flash[:error] = 'Username or password is incorrect. Please try again.'
      redirect_to new_login_path
    end
  end

  def logout
    session.delete(:user_id)

    redirect_to new_user_path
  end

end
