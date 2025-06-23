require 'open-uri'
require 'nokogiri'
require 'cgi'

class InstagramController < ApplicationController
  before_action :authenticate_user!
  def connect
    profile_url = params[:instagram_url]

    unless profile_url.include?('instagram.com')
      return redirect_back fallback_location: authenticated_root_path, alert: 'Invalid URL'
    end

    begin
      html = URI.open(profile_url, 'User-Agent' => 'Mozilla/5.0').read
      doc = Nokogiri::HTML.parse(html)

      parsed_url = URI.parse(profile_url)
      path_segments = parsed_url.path.split('/').reject(&:empty?)
      username = path_segments.first

      img_tags = doc.css('img')
      profile_pic_url = nil

      img_tags.each do |img|
        alt = img['alt']&.downcase
        next unless alt&.include?('profile picture')

        candidate = img['src']
        if candidate.include?('fbcdn.net') || candidate.include?('instagram')
          profile_pic_url = CGI.unescapeHTML(candidate)
          break
        end
      end

      current_user.update(instagram_username: username, instagram_image_url: profile_pic_url)

      redirect_to user_profile_path(current_user), notice: 'Instagram profile connected!'
    rescue StandardError => e
      Rails.logger.error e.message
      redirect_back fallback_location: authenticated_root_path, alert: 'Could not connect to Instagram.'
    end
  end
end
