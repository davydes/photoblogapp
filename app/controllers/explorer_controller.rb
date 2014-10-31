class ExplorerController < ApplicationController
  def articles
    @articles = Article.all.order('created_at DESC').last(100)
    set_last_photos
  end
  def photos
    set_last_photos
  end

  private

  def set_last_photos
    @photos = Photo.all.order('created_at DESC').last(100)
  end
end