# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :active_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy
  has_many :followeds, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  validates :username, presence: { message: 'You need a username! How else will we know what to call you?' }
  validates :username, uniqueness: { message: 'Shoot! Someone is already using this username...' }
  has_attached_file :image,
                    default_url: ':style/missing_avatar.jpg',
                    styles: {
                      thumb: ['x300', :jpeg],
                      original: [:jpeg]
                    }

  validates_attachment :image,
                       content_type: { content_type: %r{\Aimage/.*\z} }

  has_secure_password

  def self.search(query)
    where('USERNAME like ?', "%#{query}%") if query.present?
  end

  def my_likes
    posts.map { |post| post.likes.count}
  end

  def num_likes
    my_likes.inject(0) { |sum, num| sum + num}
  end

  def top_five
    User.all.sort_by { |user| -user.num_likes}
  end

  def following_posts
    followers.map(&:posts).flatten
  end

  def following_and_self_posts
    following_posts + posts
  end

  def user_ids
    User.all.map(&:id)
  end

  def following_ids
    followers.map(&:id)
  end

  def not_following
    id_array = user_ids - following_ids - [id]
    id_array.map { |id| User.find(id)}
  end

  def following?(user)
    followers.include? user
  end
end
