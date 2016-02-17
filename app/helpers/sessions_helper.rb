module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.new_remember_token
    user.touch(:last_login_time)
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    unless @current_user
      @current_user ||= User.find_by(remember_token: User.digest(cookies[:remember_token]))
      @current_user.touch(:last_login_time) if @current_user
    end
    @current_user
  end

  def current_user?(user)
    signed_in? and user == current_user
  end

  def admin?
    signed_in? and current_user.admin
  end

  def admin_or_current?(user)
    current_user?(user) or admin?
  end

  def sign_out
    return if current_user.nil?
    current_user.new_remember_token
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session.delete(:return_to) || default)
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

  def mobile?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end

end
