class CreateAlbumsPhotos < ActiveRecord::Migration
  def change
    create_table :albums_photos, :id => false  do |t|
      t.references :album
      t.references :photo
    end
    add_index :albums_photos, [:album_id, :photo_id]
    add_index :albums_photos, :photo_id
  end
end
