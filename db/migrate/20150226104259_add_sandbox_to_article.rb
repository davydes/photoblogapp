class AddSandboxToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :sandbox, :boolean, :default => false, null: false
    add_column :articles, :sandbox_at, :datetime
  end
end
