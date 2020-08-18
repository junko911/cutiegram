class User < ApplicationRecord
  has_many :posts
  validates :username, presence: true

  has_secure_password

  def self.search(query)
    if query.present?
      where('USERNAME like ?', "%#{query}%")
    else
      nil
    end
  end

  def likes
    self.posts.map {|post| post.likes}
  end

  def num_likes
    self.likes.inject(0){|sum, num| sum + num}
  end
end
