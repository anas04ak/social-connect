require "open-uri"
require "nokogiri"

class InstagramController < ApplicationController
  before_action :authenticate_user!

  def connect
    profile_url = params[:instagram_url]
    return redirect_back fallback_location: authenticated_root_path, alert: "Invalid URL" unless profile_url.include?("instagram.com")

    begin
      html = URI.open(profile_url, "User-Agent" => "Mozilla/5.0").read
      doc = Nokogiri::HTML.parse(html)

      json_data = doc.css('script[type="application/ld+json"]').text
      data = JSON.parse(json_data)

      # Get username, profile pic
      username = data["alternateName"].sub('@', '')
      profile_pic = data["image"]

      # Update user profile
      current_user.update(instagram_username: username, instagram_image_url: profile_pic)

      # Get recent 9 image URLs from page
      images = doc.css("meta[property='og:image']").map { |m| m["content"] }.uniq.first(9)

      images.each do |img_url|
        post = current_user.posts.build(
          content: "Instagram post",
          instagram_post: true,
          image: URI.open(img_url)
        )
        post.save
      end

      redirect_to user_profile_path(current_user), notice: "Instagram connected and posts imported!"
    rescue => e
      Rails.logger.error e.message
      redirect_back fallback_location: authenticated_root_path, alert: "Could not connect to Instagram."
    end
  end
end
