class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy, :like]

  def index
    @posts = Post.order('created_at DESC')
  end

  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params(:description, :image))
    @post.user = @current_user

    if @post.save!
      @post.get_tags(params[:post][:image])
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
    @post.increment!(:likes)

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
