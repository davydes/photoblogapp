class UsersController < ApplicationController
  before_action :set_user,       only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
  end

  def destroy
    @user.destroy
    flash[:success] = "User #{@user.name} successfully destroyed"
    redirect_to(users_url)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    if @user.update_attributes(user_params)
      flash[:success] = "Profile #{@user.name} saved successfully"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def correct_user
    redirect_to(root_url) unless  admin_or_current?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
