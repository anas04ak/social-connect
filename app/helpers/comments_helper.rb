module CommentsHelper
  def highlight_mentions(content)
    content.gsub(/@(\w+)/) do |match|
      username = Regexp.last_match(1)
      user = User.find_by(username: username)
      if user
        link_to("@#{username}", user_profile_path(user), class: "text-primary fw-bold")
      else
        match 
      end
    end
  end
end
