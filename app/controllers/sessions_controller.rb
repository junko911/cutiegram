# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authorized, only: %i[new create]

  def create
    user = User.find_by(username: params[:session][:username])

    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to posts_path
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
