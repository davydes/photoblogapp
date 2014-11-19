module PhotosHelper
  def image_photo_url(photo, style = :medium)
    url_to_attachment(photo.image, style)
  end

  def photo_id (photo)
    "photo_#{photo.id}"
  end

  def context_serialize(context)
    if context.instance_of?(Article) or context.instance_of?(Album)
      "#{context.class.name.downcase}-#{context.id}"
    else
      nil
    end
  end

  def link_to_photo(photo, options = nil, html_options = nil, &block)
    if options && options[:context]
      context = options.delete(:context)
      link_to in_photo_path(photo, context_serialize(context)), options, html_options, &block
    else
      link_to photo, options, html_options, &block
    end
  end

end