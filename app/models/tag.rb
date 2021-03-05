# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :post_tags
  has_many :posts, through: :post_tags

  def self.search(query)
    where('NAME like ?', "%#{query}%") if query.present?
  end

  def self.random_five_tags
    Tag.all.sample(5)
  end
end
