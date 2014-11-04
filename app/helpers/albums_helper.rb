module AlbumsHelper
  def get_album_img (album, style = :thumb)
    if album.photos.count > 0
      get_photo(album.photos.first, style);
    else
      image_url 'album_thumb.png'
    end
  end
end
