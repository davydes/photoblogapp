class ArticlesController < ApplicationController
  include UserResourceable
  before_action :set_article, only: [:publish, :publish_to_sandbox]
  before_action :check_access, only: [:publish, :publish_to_sandbox]
  skip_before_action :signed_in_user, only: :show
  respond_to :html, :js

  def index
    @articles = current_user.articles.published.order('created_at DESC').limit(100)
    @articles_in_sandbox = current_user.articles.sandbox.order('created_at DESC')
    @articles_in_drafts = current_user.articles.drafts.order('created_at DESC')
  end

  def show
    @article = Article.find(params[:id])
    access_denied if @article.is_draft? && !admin_or_current?(@article.user)
    log_impression
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

  def publish
    @article.publish
    redirect_to @article
  end

  def publish_to_sandbox
    @article.publish_to_sandbox
    redirect_to @article
  end

  private

  def log_impression
    @article.impressions.create(ip_address: request.remote_ip,user_id:current_user ? current_user.id : nil, referer: request.referer)
  end

  def set_article
    set_resource
  end

  def article_params
    params.require(:article).permit(:title, :intro, :content)
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