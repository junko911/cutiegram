class ApplicationController < ActionController::Base
  before_action :authorized

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def authorized
    redirect_to new_login_path unless set_current_user
  end

  def randomized_background_video
  videos = ["/cat.mp4", "/cat2.mp4", "/cat3.mp4", "/dog.mp4", "/dog2.mp4", "/dog3.mp4"]
  videos[rand(videos.size)]
  end
  helper_method :randomized_background_video
end
