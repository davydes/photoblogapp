class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id, null: false
      t.string :subject_type, null: false
      t.integer :subject_id, null: false
      t.string :name, null: false
      t.string :direction, null: false
      t.timestamps null: false
    end

    add_index :activities, :user_id
    add_index :activities, [:subject_type,:subject_id]
  end
end
