class RenameTableAlbumPhoto < ActiveRecord::Migration
  def self.up
    remove_index :albums_photos, [:album_id, :photo_id]
    remove_index :albums_photos, :photo_id
    rename_table :albums_photos, :photo_album_links
    add_index :photo_album_links, [:album_id, :photo_id], unique: true
    add_index :photo_album_links, :photo_id
  end

  def self.down
    remove_index :photo_album_links, [:album_id, :photo_id]
    remove_index :photo_album_links, :photo_id
    rename_table  :photo_album_links, :albums_photos
    add_index :albums_photos, [:album_id, :photo_id]
    add_index :albums_photos, :photo_id
  end
end
