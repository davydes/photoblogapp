class SessionsController < ApplicationController
  respond_to :html

  def index
    if signed_in?
      redirect_to :root
    else
      render 'new'
    end
  end

  def new
    redirect_to current_user if signed_in?
    session[:return_to] ||= request.referer
  end

  def create
    user = User.find_for_auth(params[:session][:login].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = t('users.login_incorrect')
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
