require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  include SessionsHelper

  setup do
    @article = articles(:one)
    @user = users(:user_1)
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

  test "should get edit" do
    user = User.find_by_email(@user.email)
    sign_in(user)
    get :edit, id: @article
    assert_response :success
    sign_out
  end

  test "should update article" do
    user = User.find_by_email(@user.email)
    sign_in(user)
    patch :update, id: @article, article: { content: @article.content, title: @article.title }
    assert_redirected_to article_path(assigns(:article))
    sign_out
  end

  test "should destroy article" do
    user = User.find_by_email(@user.email)
    sign_in(user)

    assert_difference('Article.count', -1) do
      delete :destroy, id: @article
    end

    assert_redirected_to articles_path
    sign_out
  end

end
