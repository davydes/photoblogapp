class AddPublisherToUser < ActiveRecord::Migration
  def change
    add_column :users, :publisher, :boolean, :default => false, null: false
  end
end
