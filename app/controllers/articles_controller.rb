class ArticlesController < ApplicationController
  include UserResourceable
  skip_before_action :signed_in_user, only: :show
  respond_to :html, :js

  def index
    @articles = current_user.articles.published.order('created_at DESC').limit(100)
    @drafts = current_user.articles.drafts.order('created_at DESC')
  end

  def show
    @article = Article.find(params[:id])
    access_denied if @article.is_draft? && !admin_or_current?(@article.user)
  end

  def new
    @article =  current_user.articles.new
  end

  def edit
  end

  def create
    @article = current_user.articles.new(article_params)
    preview || save_or_render(:new)
  end

  def update
    @article.assign_attributes(article_params)
    preview || save_or_render(:edit)
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: 'Article was successfully destroyed.'
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end

  def preview
    @show_preview = (request.format == :js)
    if @show_preview
      @article.valid?
      render 'preview'
    end
  end

  def save_or_render(action)
    if @article.save
      redirect_to @article
    else
      render action
    end
  end
end