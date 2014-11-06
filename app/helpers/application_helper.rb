module ApplicationHelper

  def bootstrap_class_for (flash_type)
    {
      'success' => 'alert-success',
      'error' => 'alert-danger',
      'alert' => 'alert-warning',
      'notice' => 'alert-info'
    }[flash_type] || flash_type.to_s
  end

  def badge (count)
    html = "<span class=\"badge pull-right\">#{count}</span>"
    html.html_safe
  end

  def url_to_attachment(attachment, style = nil)
    return attachment.url(style) unless (Rails.env.production? && attachment.file?) #default
    style = attachment.options[:default_style] if style.nil?
    id = attachment.instance.id
    c_name = attachment.instance.class.name.pluralize.downcase
    a_name = attachment.name.to_s.pluralize.downcase
    hash_data = "#{c_name}/#{a_name}/#{id}"
    hash_secret = Paperclip::Attachment.default_options[:hash_secret]
    hash_digest = Paperclip::Attachment.default_options[:hash_digest]
    hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.const_get(hash_digest).new, hash_secret, hash_data)
    "https://photoblogapp.storage.googleapis.com/#{c_name}/#{a_name}/#{hash}/#{id}_#{style}.#{attachment.styles[style][:format].to_s}"
  end

end
