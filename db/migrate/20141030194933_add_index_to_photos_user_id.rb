class AddIndexToPhotosUserId < ActiveRecord::Migration
  def change
    add_index :photos, :user_id
  end
end
