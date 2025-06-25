class InstagramController < ApplicationController
  before_action :authenticate_user!

  def connect
    profile_url = params[:instagram_url]

    unless profile_url.include?('instagram.com')
      return redirect_back fallback_location: authenticated_root_path, alert: 'Invalid Instagram URL'
    end

    InstagramConnectJob.perform_later(current_user.id, profile_url)

    redirect_to user_profile_path(current_user), notice: 'Connecting to Instagram... Posts will appear shortly.'
  end

  def disconnect
    current_user.avatar.purge if current_user.avatar.attached?

    if current_user.backup_avatar.attached?
      current_user.avatar.attach(current_user.backup_avatar.blob)
      current_user.backup_avatar.purge
    end

    current_user.update(
      instagram_username: nil,
      instagram_image_url: nil
    )

    current_user.posts.where(source: :instagram).destroy_all

    redirect_to user_profile_path(current_user), notice: 'Instagram account disconnected.'
  end

  def new; end
end
