class MentionMailer < ApplicationMailer
  def mention_email
    @user = params[:user]
    @comment = params[:comment]
    @post = @comment.post

    mail(
      to: @user.email,
      subject: "#{@comment.user.username || @comment.user.email} mentioned you in a comment"
    )
  end
end
