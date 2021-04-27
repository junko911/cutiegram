class TagGenerator
  def self.call(post, image)
    api_key = ENV['GOOGLE_API_KEY']
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
    request['Content-Type'] = 'application/json'
    response = https.request(request, body)
    results = JSON.parse(response.body)
    results['responses'][0]['labelAnnotations'].each do |result|
      tag = Tag.find_or_create_by(name: result['description'])
      PostTag.create(post_id: post.id, tag_id: tag.id)
    end
  end
end
