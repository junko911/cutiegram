class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :post_tags
  has_many :tags, through: :post_tags
  validates :description, presence: true
  validates :image, presence: true
  has_attached_file :image,
                    styles: {
                            thumb: ["x300", :jpeg],
                            original: [:jpeg]
                        }
  validates_attachment :image,
                     content_type: { content_type: /\Aimage\/.*\z/ }

  def get_tag(image)
    IMAGE_FILE = image

    API_KEY = 'AIzaSyCsDEMOxArkb1NhkJ3obOGTlu7fnTcZ578'
    API_URL = "https://vision.googleapis.com/v1/images:annotate?key=#{API_KEY}"

    # Encode images to base64
    base64_image = Base64.strict_encode64(File.new(IMAGE_FILE, 'rb').read)

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
    uri = URI.parse(API_URL)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request["Content-Type"] = "application/json"
    response = https.request(request, body)

    # print response in console
    puts response.body
  end
end
