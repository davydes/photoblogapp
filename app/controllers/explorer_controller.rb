class ExplorerController < ApplicationController
  respond_to :html

  def index
    @photos = Photo.all.order('created_at DESC').last(100)
    set_last_articles
  end

  def articles
    set_last_articles
  end

  def photos
    @photos = Photo.all.order('created_at DESC').page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.js { render 'photos/index.js'}
    end
  end

  private

  def set_last_articles
    @articles = Article.published.order('created_at DESC').last(30)
  end
end