class ArticlesController < ApplicationController
  before_action :signed_in_user, only: [:new, :edit, :update, :destroy]
  before_action :set_article, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

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
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      if current_user.admin?
        @article = User.find(params[:user_id]).articles.find(params[:id])
      else
        @article = current_user.articles.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :content)
    end

    def correct_user
      redirect_to root_path unless admin_or_current?(@article.user)
    end

end