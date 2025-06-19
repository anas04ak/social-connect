class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :mentions
  has_many :mentions_in_comments, through: :mentions, source: :comment

  has_one_attached :avatar

  def age
    return unless date_of_birth.present?

    current_date = Time.zone.today
    age = current_date.year - date_of_birth.year
    age -= 1 if date_of_birth > current_date.years_ago(age)
    age
  end
end
