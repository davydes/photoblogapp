class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :commentable_id
      t.string :commentable_type
      t.text :content
      t.timestamps
    end
    add_index :comm0ents, :name, unique: true
  end
  end
end
