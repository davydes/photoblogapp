module AlbumsHelper
  def image_album_url(album, style = :thumb)
    if album.photos.count > 0
      image_photo_url(album.photos.first, style);
    else
      '/images/album_s320.png'
    end
  end

  def album_id(album)
    "user_#{album.user.id}_album_#{album.id}"
  end
end
