class User < ApplicationRecord
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :likes
  
  validates :username, presence: { message: 'You need a username! How else will we know what to call you?'}
  validates :username, uniqueness: { message: 'Shoot! Someone is already using this username...'}
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

  def my_likes
    self.posts.map {|post| post.likes.count}
  end

  def num_likes
    self.my_likes.inject(0){|sum, num| sum + num}
  end

  def top_five
    User.all.sort_by {|user| -user.num_likes}
  end
end
