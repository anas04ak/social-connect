class InstagramConnectJob < ApplicationJob
  queue_as :default

  def perform(user_id, profile_url)
    user = User.find_by(id: user_id)
    return unless user

    InstagramConnectService.new(user, profile_url).call
  end
end
