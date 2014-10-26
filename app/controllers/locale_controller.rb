class LocaleController < ApplicationController
  def english
    I18n.locale = :en
    set_session_and_redirect
  end

  def russian
    I18n.locale = :ru
    set_session_and_redirect
  end

  private
  def set_session_and_redirect
    session[:locale] = I18n.locale
    redirect_to :back || :root
  rescue ActionController::RedirectBackError
    redirect_to :root
  end
end