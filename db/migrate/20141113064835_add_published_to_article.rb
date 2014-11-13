class AddPublishedToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :published, :boolean, :default => false
    add_column :articles, :published_at, :datetime

    reversible do |dir|
      dir.up do
        Article.drafts.update_all "published = 't', published_at = created_at"
      end
    end
  end
end
