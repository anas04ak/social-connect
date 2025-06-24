class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, -> { where(parent_id: nil) }, dependent: :destroy

  scope :instagram, -> { where(instagram_post: true) }

  has_one_attached :image

  enum source: {
    original: 0,
    instagram: 1
  }

  validates :external_id, presence: true, if: -> { instagram? }
end
