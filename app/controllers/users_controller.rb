class UsersController < ApplicationController
    before_action :find_user, except: [:index, :new, :create]
    skip_before_action :authorized, only: [:new, :create]

    # def index
    #     @users = User.search(params[:query])
    #     render :index
    # end

    def show
    end

    def new
        @user = User.new
    end

    def create
        @user = User.create(user_params(:username, :password, :password_confirmation, :query))
        if @user.valid?
            session[:user_id] = @user.id
            redirect_to posts_path
        else
            render :new
        end
    end

    def edit
    end

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
