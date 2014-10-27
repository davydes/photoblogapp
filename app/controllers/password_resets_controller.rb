class PasswordResetsController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_url, :notice => t('users.password_reset.email_sent')
  end

  def edit
  end

  def update
    if @user.update_attributes(user_reset_pwd_params)
      redirect_to signin_url, :notice => t('users.password_reset.password_reset')
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def check_expiration
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => t('users.password_reset.link_expired')
    end
  end

  def user_reset_pwd_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
