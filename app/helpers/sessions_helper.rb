module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.new_remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by(remember_token: User.digest(cookies[:remember_token]))
  end

  def current_user?(user)
    user == current_user
  end

  def admin_or_current?(user)
    signed_in? and
        (current_user?(user) or current_user.admin)
  end

  def admin?
    signed_in? and current_user.admin
  end

  def sign_out
    return if current_user.nil?
    current_user.new_remember_token
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url
    end
  end

end
