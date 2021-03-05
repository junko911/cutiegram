# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, except: %i[index new create]
  skip_before_action :authorized, only: %i[new create]

  def following
    @users = @user.followers
  end

  def followed
    @users = @user.followeds
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params(:username, :password, :password_confirmation, :image, :query))

    if @user.valid?
      session[:user_id] = @user.id
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit; end

  def update
    @user.update(user_params(:username, :password, :password_confirmation, :image, :location, :query))
    session[:user_id] = @user.id
    if @user.valid?
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to new_user_path
  end

  def follow
    Relationship.create(follower: @user, followed: @current_user)
    redirect_to @user
  end

  def unfollow
    @relationship = Relationship.find_by(follower: @user, followed: @current_user)
    @relationship.destroy
    redirect_to posts_path
  end

  private

  def user_params(*args)
    params.require(:user).permit(*args)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
