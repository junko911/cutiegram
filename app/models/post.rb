# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :likes, dependent: :destroy

  validates :description, presence: { message: 'Post needs a description!' }
  validates :image, presence: { message: 'Post needs an image!' }
  has_attached_file :image,
                    styles: {
                      thumb: ['x300', :jpeg],
                      original: [:jpeg]
                    }
  validates_attachment :image,
                       content_type: { content_type: %r{\Aimage/.*\z} }

  def liked?(user)
    !!likes.find { |like| like.user_id == user.id}
  end
end
