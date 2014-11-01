class ArticlesController < ApplicationController
  include UserResource

  def index
    @articles = User.find(params[:user_id]).articles.all.order('created_at DESC').limit(100)
  end

  def show
    @article =  User.find(params[:user_id]).articles.find(params[:id])
  end

  def new
    @article =  User.find(params[:user_id]).articles.new()
  end

  def edit
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      redirect_to [@article.user, @article], notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to [@article.user, @article], notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to user_articles_path(@article.user), notice: 'Article was successfully destroyed.'
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end

end