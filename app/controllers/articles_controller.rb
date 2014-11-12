class ArticlesController < ApplicationController
  include UserResourceable
  respond_to :html, :js

  def index
    @articles = @owner.articles.all.order('created_at DESC').limit(100)
  end

  def show
    @article =  @owner.articles.find(params[:id])
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
    redirect_to user_articles_path(@article.user), notice: 'Article was successfully destroyed.'
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end

  def preview
    if @show_preview = (request.format == :js)
      @article.valid?
      render 'preview'
    end
  end

  def save_or_render(action)
    if @article.save
      redirect_to [@article.user, @article]
    else
      render action
    end
  end
end