class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, -> { where(parent_id: nil) }, dependent: :destroy
  
  has_one_attached :image
end
