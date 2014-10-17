require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  include SessionsHelper

  setup do
    @article = articles(:one)
    @user = users(:user_0)
    @admin = users(:admin_user)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should get new" do
    user = User.find_by_email(@user.email)
    sign_in(user)
    get :new
    assert_response :success
    sign_out
  end

  test "should create article" do
    user = User.find_by_email(@user.email)
    sign_in(user)

    assert_difference('Article.count') do
      post :create, article: { content: @article.content, title: @article.title }
    end

    assert_redirected_to article_path(assigns(:article))
    sign_out
  end

  test "should show article" do
    get :show, id: @article
    assert_response :success
  end

  test "should get edit by admin" do
    user_article = @user.articles.first
    sign_in(@admin)
    get :edit, id: user_article
    assert_response :success
    sign_out
  end

  test "should update article by admin" do
    user_article = @user.articles.first
    sign_in(@admin)
    patch :update, id: user_article, article: { content: @article.content, title: @article.title }
    assert_redirected_to article_path(assigns(:article))
    sign_out
  end

  test "should destroy article by admin" do
    user_article = @user.articles.first
    sign_in(@admin)

    assert_difference('Article.count', -1) do
      delete :destroy, id: user_article
    end

    assert_redirected_to articles_path
    sign_out
  end

end
