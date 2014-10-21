class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:session][:login].downcase) ||
           User.find_by(email: params[:session][:login].downcase)

    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid login/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  def switch_format
    session[:preferred_format] = params[:preferred_format]
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to :root
  end
end
