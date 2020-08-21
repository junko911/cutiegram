class Tag < ApplicationRecord
    has_many :post_tags
    has_many :posts, through: :post_tags

    def self.search(query)
        if query.present?
            where('NAME like ?', "%#{query}%")
        else
            nil
        end
    end

    def self.random_five_tags
        Tag.all.sample(5)
    end
end
