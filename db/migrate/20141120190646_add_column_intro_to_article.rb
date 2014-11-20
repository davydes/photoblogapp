class AddColumnIntroToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :intro, :text, :limit => 255
  end
end
