require 'ferrum'
require 'nokogiri'
require 'open-uri'
require 'cgi'

class InstagramController < ApplicationController
  before_action :authenticate_user!

  def connect
    profile_url = params[:instagram_url]

    unless profile_url.include?('instagram.com')
      return redirect_back fallback_location: authenticated_root_path, alert: 'Invalid Instagram URL'
    end

    begin
      browser = Ferrum::Browser.new(timeout: 15, browser_options: { 'no-sandbox': nil })
      browser.goto(profile_url)
      sleep 5
      html = browser.body
      browser.quit

      doc = Nokogiri::HTML.parse(html)
      img_tags = doc.css('img')

      profile_pic_url = img_tags.first['src']

      post_img_urls = img_tags.map { |img| img['src'] }
                              .reject { |url| url == profile_pic_url }
                              .uniq
                              .first(9)

      parsed_url = URI.parse(profile_url)
      username = parsed_url.path.split('/').reject(&:empty?).first

      download_and_attach_image(profile_pic_url) if profile_pic_url
      current_user.update(instagram_username: username)

      current_user.instagram_photos.destroy_all

      post_img_urls.each_with_index do |img_url, index|
        file = URI.open(img_url, 'User-Agent' => 'Mozilla/5.0')
        photo = current_user.instagram_photos.build
        photo.image.attach(io: file, filename: "insta_post_#{index + 1}.jpg", content_type: 'image/jpeg')
        photo.save
      end

      redirect_to user_profile_path(current_user), notice: 'Instagram profile and posts connected!'
    rescue StandardError => e
      Rails.logger.error "[Instagram Connect Error] #{e.class}: #{e.message}"
      redirect_back fallback_location: authenticated_root_path,
                    alert: 'Something went wrong while connecting to Instagram.'
    end
  end

  def disconnect
    current_user.update(
      instagram_username: nil,
      instagram_image_url: nil
    )
    current_user.instagram_photos.destroy_all
    redirect_to user_profile_path(current_user), notice: 'Instagram account disconnected.'
  end

  def new
  end

  private

  def download_and_attach_image(url)
    filename = File.basename(URI.parse(url).path)
    file = URI.open(url, 'User-Agent' => 'Mozilla/5.0')
    current_user.avatar.attach(io: file, filename: filename, content_type: 'image/jpeg')
  end
end
