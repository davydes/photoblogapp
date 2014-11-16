module PhotosHelper
  def image_photo_url(photo, style = :medium)
    url_to_attachment(photo.image, style)
  end

  def photo_id (album)
    "user_#{album.user.id}_photo_#{album.id}"
  end

  def link_to_photo(name = nil, options = nil, html_options = nil, &block)
    if options && options[:context]
      link_to in_photo_path(name, options[:context]), options, html_options, &block
    else
      link_to name, options, html_options, &block
    end
  end
end