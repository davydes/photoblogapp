class ApplicationController < ActionController::Base
  before_action :set_locale
  before_filter :handle_mobile
  before_filter :use_preferred_format

  # Comment out when use only ajax content for mobile version

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper
  include ApplicationHelper

  private

  def handle_mobile
    request.format = :mobile if mobile_user_agent?
  end

  def use_preferred_format
    if request.format == 'html' && session[:preferred_format] == 'mobile'
      request.format = :mobile
    end
    if request.format == 'mobile' && session[:preferred_format] == 'html'
      request.format = :html
    end
  end

  def force_mobile_format
    session[:preferred_format] = 'mobile'
    request.format = :mobile
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end
end