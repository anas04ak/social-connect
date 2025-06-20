class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.where(parent_id: nil)
                      .order(created_at: :asc)
                      .offset(params[:offset].to_i)
                      .limit(3)

    render partial: "comments/comment", collection: @comments, as: :comment, locals: { depth: 1 }
  end
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      # 🔔 Notify post owner (but avoid notifying self)
      if @post.user != current_user
        Notification.create(
          recipient: @post.user,
          actor: current_user,
          action: "commented on your post",
          notifiable: @comment
        )
      end

      # 🔍 Extract mentioned users
      mentioned_users = extract_mentioned_users(@comment)

      mentioned_users.each do |user|
        # Avoid notifying the same user twice (e.g., post owner already notified)
        next if user == current_user

        # 💾 Save mention record
        Mention.create(user: user, comment: @comment)

        # 📬 Send email
        MentionMailer.with(user: user, comment: @comment).mention_email.deliver_later

        # 🛎 In-app notification
        Notification.create(
          recipient: user,
          actor: current_user,
          action: "mentioned you",
          notifiable: @comment
        )
      end

      redirect_to @post, notice: "Comment posted!"
    else
      redirect_to @post, alert: "Failed to post comment."
    end
  end


  def edit
    @comment = Comment.find(params[:id])
    unless @comment.user == current_user
      redirect_back fallback_location: root_path, alert: "Not authorized to edit this comment."
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.user != current_user
      redirect_back fallback_location: root_path, alert: "Not authorized."
    elsif @comment.update(comment_params)
      redirect_to post_path(@comment.post), notice: "Comment updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.user == current_user
      comment.destroy
      redirect_back fallback_location: post_path(comment.post), notice: "Comment deleted."
    else
      redirect_back fallback_location: post_path(comment.post), alert: "You are not authorized."
    end
  end

  private
  
  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def extract_mentioned_users(comment)
    usernames = comment.content.scan(/@(\w+)/).flatten.uniq
    users = User.where(username: usernames)

    users.each do |user|
      Mention.create(user: user, comment: comment)
    end
  end
end
