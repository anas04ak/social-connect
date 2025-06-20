class User < ApplicationRecord
  # Devise modules...
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :mentions
  has_many :mentions_in_comments, through: :mentions, source: :comment

  # 👇 Fix: correct associations
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :sent_notifications, class_name: "Notification", foreign_key: :actor_id, dependent: :nullify

  has_one_attached :avatar

  def age
    return unless date_of_birth.present?

    current_date = Time.zone.today
    age = current_date.year - date_of_birth.year
    age -= 1 if date_of_birth > current_date.years_ago(age)
    age
  end
end
