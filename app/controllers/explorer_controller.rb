class ExplorerController < ApplicationController
  def index
    set_last_articles
    set_last_photos
  end

  def articles
    set_last_articles
  end

  def photos
    set_last_photos
  end

  private

  def set_last_articles
    @articles = Article.all.order('created_at DESC').last(100)
  end

  def set_last_photos
    @photos = Photo.all.order('created_at DESC').last(100)
  end
end