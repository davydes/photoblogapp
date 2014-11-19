class ApplicationController < ActionController::Base
  before_action :set_locale

  # Comment out when use only ajax content for mobile version

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  private

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def access_denied
    raise ActionController::RoutingError.new('Access Denied')
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end