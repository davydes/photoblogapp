class ExplorerController < ApplicationController
  respond_to :html

  def index
    @photos = Photo.all.last(100)
    set_last_articles
  end

  def articles
    set_last_articles
  end

  def photos
    @photos = Photo.all.page(params[:page])
  end

  private

  def set_last_articles
    @articles = Article.published.order('created_at DESC').last(30)
  end
end