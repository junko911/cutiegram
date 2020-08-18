class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  validates :description, presence: true
  has_attached_file :image,
                    styles: {
                            thumb: ["x300", :jpeg],
                            original: [:jpeg]
                        }
  validates_attachment :image,
                     content_type: { content_type: /\Aimage\/.*\z/ }
end
