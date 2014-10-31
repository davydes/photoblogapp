class FormatController < ActionController::Base
  def mobile
    set_session_and_redirect 'mobile'
  end

  def desktop
    set_session_and_redirect 'html'
  end

  private

  def set_session_and_redirect(format)
    session[:preferred_format] = format
    redirect_to :back || :root
  rescue ActionController::RedirectBackError
    redirect_to :root
  end
end