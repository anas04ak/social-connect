require 'ferrum'
require 'nokogiri'
require 'open-uri'
require 'cgi'

class InstagramConnectService
  MAX_RETRIES = 3

  def initialize(user, profile_url)
    @user = user
    @profile_url = profile_url
    @browser = Ferrum::Browser.new(timeout: 15, browser_options: { 'no-sandbox': nil })
  end

  def call
    raise 'Invalid Instagram URL' unless @profile_url.include?('instagram.com')

    attempt = 0
    begin
      attempt += 1
      scrape_and_save_data
    rescue StandardError => e
      retry if attempt < MAX_RETRIES
      Rails.logger.error("[InstagramConnectService Error] #{e.class}: #{e.message}")
      raise e
    ensure
      @browser.quit if @browser&.context&.page
    end
  end

  private

  def scrape_and_save_data
    @browser.goto(@profile_url)
    sleep 5
    doc = Nokogiri::HTML.parse(@browser.body)

    profile_pic_url = doc.css('img').first&.[]('src')
    parsed_url = URI.parse(@profile_url)
    username = parsed_url.path.split('/').reject(&:empty?).first

    download_and_attach_avatar(profile_pic_url) if profile_pic_url
    @user.update(instagram_username: username)

    post_img_urls = doc.css('img').map { |img| img['src'] }
                       .reject { |url| url == profile_pic_url }
                       .uniq.first(9)

    @user.posts.where(source: :instagram).destroy_all

    post_img_urls.each_with_index do |img_url, index|
      file = URI.open(img_url, 'User-Agent' => 'Mozilla/5.0')
      post = @user.posts.build(
        content: '',
        source: :instagram,
        external_id: "img_#{index + 1}"
      )
      post.image.attach(io: file, filename: "insta_post_#{index + 1}.jpg", content_type: 'image/jpeg')
      post.save!
    end
  end

  def download_and_attach_avatar(url)
    file = URI.open(url, 'User-Agent' => 'Mozilla/5.0')
    @user.avatar.attach(io: file, filename: 'instagram_avatar.jpg', content_type: 'image/jpeg')
  end
end
