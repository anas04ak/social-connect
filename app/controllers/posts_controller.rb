class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[edit update destroy show]
  before_action :authorize_user!, only: %i[edit update destroy]
  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post succesfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :image, :title)
  end

  def authorize_user!
    redirect_to posts_path, alert: 'Not authorized' unless @post.user == current_user
  end
end
