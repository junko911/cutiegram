class UsersController < ApplicationController
    before_action :find_user, except: [:new, :create]
    def show
        @users = User.all
    end

    def new
        @user = User.new(user_params)
    end

    def create
        @user = User.create(user_params)
        if user.valid?
            redirect_to user_path(@user)
        else
            redirect_to new_user_path
        end
    end

    def edit
    end

    def update
        @user.update(user_params)
        if user.valid?
            redirect_to user_path(@user)
        else
            flash[:errors] = @user.errors.full_messages
            redirect_to edit_user_path(@user)
        end
    end

    def destroy
        @user.destroy
        redirect_to new_user_path
    end

    private

    def user_params
        params.require(:user).permit(:username)
    end

    def find_user
        @user = User.find(params[:id])
    end
end
