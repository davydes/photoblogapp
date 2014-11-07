module PhotosHelper
  def image_photo_url(photo, style = :medium)
    url_to_attachment(photo.image, style)
  end

  def photo_id (album)
    "user_#{album.user.id}_photo_#{album.id}"
  end
end