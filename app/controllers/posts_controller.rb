# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :find_post, only: %i[show edit update destroy like]

  def index
    @posts = current_user.following_and_self_posts.sort_by(&:created_at).reverse
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params(:description, :image))

    if @post.save
      TagGenerator.call(@post, params[:post][:image])
      redirect_to @post
    else
      render :new
    end
  end

  def update
    if @post.update(post_params(:description))
      redirect_to @post
    else
      render :edit
    end
  end

  def destroy
    user = @post.user
    @post.destroy
    redirect_to user_path(user)
  end

  def like
    @post = Post.find(params[:id])
    Like.create(user_id: @current_user.id, post_id: @post.id)
    redirect_to post_path(@post)
  end

  def unlike
    @post = Post.find(params[:id])
    like = Like.find_by(user_id: @current_user.id, post_id: @post.id)
    like.destroy
    redirect_to post_path(@post)
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params(*args)
    params.require(:post).permit(*args)
  end
end
