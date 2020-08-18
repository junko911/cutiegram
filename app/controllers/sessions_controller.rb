class SessionsController < ApplicationController
  def create
    @user = User.find_by(username: params[:session][:username])

    if @user && user.authenticate([params[:session][:password]])
      session[:user_id] = user.id
      redirect_to user
    else
      render :new
    end
  end

  def logout
    session.delete(:user_id)

    redirect_to new_user_path
  end

end
