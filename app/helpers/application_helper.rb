module ApplicationHelper

  def bootstrap_class_for (flash_type)
    {
      'success' => 'alert-success',
      'error' => 'alert-danger',
      'alert' => 'alert-warning',
      'notice' => 'alert-info'
    }[flash_type] || flash_type.to_s
  end

  def badge (count, position = :right)
    position_css = ''
    if position == :right
      position_css = 'pull-right'
    elsif position == :left
      position_css = 'pull-left'
    end
    html = "<span class=\"badge #{position_css}\">#{count}</span>"
    html.html_safe
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end

  def attachment_hash(klass, id, name)
    hash_data = "#{klass}/#{name}/#{id}"
    hash_secret = Paperclip::Attachment.default_options[:hash_secret]
    hash_digest = Paperclip::Attachment.default_options[:hash_digest]
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.const_get(hash_digest).new, hash_secret, hash_data)
  end

  def url_to_attachment(attachment, style = nil)
    #default
    return attachment.url(style) unless (Rails.env.production? && attachment.file?)
    style = attachment.options[:default_style] if style.nil?
    id = attachment.instance.id
    klass = attachment.instance.class.name.pluralize.downcase
    name = attachment.name.to_s.pluralize.downcase
    "https://photoblogapp.storage.googleapis.com"+
      "/#{klass}/#{name}/#{attachment_hash(klass,id,name)}/"+
      "#{id}_#{style}.#{attachment.styles[style][:format].to_s}"
  end

end
