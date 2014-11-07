module AlbumsHelper
  def image_album_url (album, style = :thumb)
    if album.photos.count > 0
      image_photo_url(album.photos.first, style);
    else
      image_url 'album_thumb.png'
    end
  end

  def album_id (album)
    "user##{album.user.id}album##{album.id}"
  end
end
