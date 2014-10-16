require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include SessionsHelper

  setup do
    @user = users(:one)
  end

  test "should get index" do
    user = User.find_by_email(@user.email)
    sign_in(user)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    sign_out
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { email: 'test_create@mail.org', name: 'create_test', password: 'password', password_confirmation: 'password' }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    user = User.find_by_email(@user.email)
    sign_in(user)
    get :edit, id: @user
    sign_out
    assert_response :success
  end

  test "should update user with password" do
    user = User.find_by_email(@user.email)
    sign_in(user)
    patch :update, id: @user, user: { email: @user.email, name: @user.name, password: 'qwerty', password_confirmation: 'qwerty' }
    assert_redirected_to user_path(assigns(:user))
    sign_out
  end

  test "should not update user different password and confirmation" do
    user = User.find_by_email(@user.email)
    sign_in(user)
    patch :update, id: @user, user: { email: @user.email, name: @user.name, password: 'qwerty', password_confirmation: 'qwertyu' }
    assert_response :success
    sign_out
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      user = User.find_by_email(@user.email)
      sign_in(user)
      delete :destroy, id: @user
      sign_out
    end

    assert_redirected_to users_path
  end
end
