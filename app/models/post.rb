class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :post_tags, :dependent => :destroy
  has_many :tags, through: :post_tags
  has_many :likes, :dependent => :destroy

  validates :description, presence: { message: "Post needs a description!"}
  validates :image, presence: { message: "Post needs an image!"}
  has_attached_file :image,
                    styles: {
                            thumb: ["x300", :jpeg],
                            original: [:jpeg]
                        }
  validates_attachment :image,
                     content_type: { content_type: /\Aimage\/.*\z/ }

  def liked?(user)
    !!self.likes.find {|like| like.user_id == user.id}
  end

  def get_tags(image)
    api_key = ENV["GOOGLE_API_KEY"]
    api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{api_key}"
    # Encode images to base64
    base64_image = Base64.strict_encode64(File.new(image, 'rb').read)

    # Build JSON format
    body = {
      requests: [{
        image: {
          content: base64_image
        },
        features: [
          {
            type: 'LABEL_DETECTION',
            maxResults: 5
          }
        ]
      }]
    }.to_json

    # Send request to Cloud Vision API
    uri = URI.parse(api_url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request["Content-Type"] = "application/json"
    response = https.request(request, body)
    results = JSON.parse(response.body)
    results["responses"][0]["labelAnnotations"].each { |result| 
      tag = Tag.find_or_create_by(name: result["description"])
      PostTag.create(post_id: self.id, tag_id: tag.id)
    }
  end
end
