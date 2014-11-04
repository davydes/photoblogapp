module AlbumsHelper
  def get_album_thumb(album)
    if album.photos.count > 0
      get_photo(album.photos.first,:thumb);
    else
      'album_thumb.png'
    end
  end
end
