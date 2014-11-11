class CreateTableArticlesPhotos < ActiveRecord::Migration
  def change
    create_table :articles_photos, :id => false do |t|
      t.references :article
      t.references :photo
    end
    add_index :articles_photos, [:article_id, :photo_id], unique: true
    add_index :articles_photos, :photo_id
  end
end
