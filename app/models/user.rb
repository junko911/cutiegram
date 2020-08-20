class User < ApplicationRecord
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  validates :username, presence: true
  validates :username, uniqueness: true
  has_attached_file :image,
                    styles: {
                            thumb: ["x300", :jpeg],
                            original: [:jpeg]
                        }
  validates_attachment :image,
                     content_type: { content_type: /\Aimage\/.*\z/ }

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

  def top_five
    User.all.sort_by {|user| user.num_likes}
  end
end
