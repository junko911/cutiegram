# frozen_string_literal: true

class SearchesController < ApplicationController
  def index
    @users = User.search(params[:query])
    tags = Tag.search(params[:query])
    @posts = tags.map(&:posts).flatten.uniq
    render :index
  end
end
