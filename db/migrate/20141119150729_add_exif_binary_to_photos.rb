class AddExifBinaryToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :exif_binary, :binary
  end
end
