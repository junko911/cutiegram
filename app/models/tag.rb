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
end
