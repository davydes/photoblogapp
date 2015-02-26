class ExplorerController < ApplicationController
  respond_to :html

  def index
    @photos = Photo.all.last(100)
    set_last_articles(false)
  end

  def articles
    set_last_articles(false)
  end

  def articles_in_sandbox
    set_last_articles(true)
    render :articles
  end

  def photos
    @photos = Photo.all.page(params[:page])
  end

  private

  def set_last_articles(sandbox_mode)
    @articles = sandbox_mode ? Article.sandbox.order('created_at DESC').last(30) : Article.published.order('created_at DESC').last(30)
  end
end