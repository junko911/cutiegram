class SearchesController < ApplicationController
    def index
        @users = User.search(params[:query]) 
        tags = Tag.search(params[:query])
        @posts = tags.map{|tag| tag.posts}.flatten.uniq
        render :index
    end
end
