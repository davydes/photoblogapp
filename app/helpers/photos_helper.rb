module PhotosHelper
  def image_photo_url(photo, style = :medium)
    url_to_attachment(photo.image, style)
  end
end