module PhotosHelper
  def get_photo(photo, style = :medium)
    if Rails.env.production?
      # default url
      return photo.image.url(style) unless photo.image?
      # get GAPI Url
      data = "photos/images/#{photo.id}"
      hash_secret = Paperclip::Attachment.default_options[:hash_secret]
      hash_digest = Paperclip::Attachment.default_options[:hash_digest]
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.const_get(hash_digest).new, hash_secret, data)
      "https://photoblogapp.storage.googleapis.com/photos/images/#{hash}/#{photo.id}_#{style}.jpg"
    else
      photo.image.url(style)
    end
  end
end