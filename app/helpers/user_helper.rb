module UserHelper
  def get_avatar(user, style = :thumb)
    if Rails.env.production?
      # default url
      return user.avatar.url(style) unless user.avatar?
      # get GAPI url
      data = "users/avatars/#{self.id}"
      hash_secret = Paperclip::Attachment.default_options[:hash_secret]
      hash_digest = Paperclip::Attachment.default_options[:hash_digest]
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.const_get(hash_digest).new, hash_secret, data)
      "https://photoblogapp.storage.googleapis.com/users/avatars/#{hash}/#{user.id}_#{style}.png"
    else
      user.avatar.url(style)
    end
  end
end
