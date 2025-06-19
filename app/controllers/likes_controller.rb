class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    likeable = find_likeable
    likeable.likes.create(user: current_user)
    redirect_back fallback_location: posts_path
  end

  def destroy
    like = Like.find(params[:id])
    like.destroy if like.user == current_user
    redirect_back fallback_location: posts_path
  end

  private

  def find_likeable
    params[:likeable_type].constantize.find(params[:likeable_id])
  end
end
