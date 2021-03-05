# frozen_string_literal: true

module ApplicationHelper
  def randomized_background_video
    videos = ['/cat.mp4', '/cat2.mp4', '/cat3.mp4', '/dog.mp4', '/dog2.mp4', '/dog3.mp4']
    videos[rand(videos.size)]
  end
end
