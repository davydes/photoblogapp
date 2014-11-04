class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :destroy, :crop_avatar]
  before_action :set_user,       only: [:show, :edit, :update, :destroy, :crop_avatar]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.all
  end

  def new
    redirect_to current_user if signed_in?
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
    if @user.valid? && verify_recaptcha(:model => @user) && @user.save
      sign_in @user
      if user_params[:avatar].blank?
        redirect_to @user
      else
        render 'crop_ava'
      end
    else
      flash.delete(:recaptcha_error)
      render 'new'
    end

  end

  def edit
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    if @user.update_attributes(user_params)
      flash[:success] = "Profile #{@user.name} saved successfully"
      if user_params[:avatar].blank?
        redirect_to @user
      else
        render 'crop_ava'
      end
    else
      render 'edit'
    end
  end

  def crop_avatar
    @user.update_attributes(crop_ava_params)
    @user.avatar.reprocess!
    redirect_to @user
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :avatar)
  end

  def crop_ava_params
    params.require(:user).permit(:crop_x, :crop_y, :crop_w, :crop_h)
  end

  def correct_user
    redirect_to(root_url) unless  admin_or_current?(@user)
  end

  def admin_user
    redirect_to(root_url) unless admin?
  end
end
