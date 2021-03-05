# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authorized

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authorized
    redirect_to new_login_path unless current_user
  end

  helper_method :current_user
end
