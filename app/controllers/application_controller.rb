class ApplicationController < ActionController::Base
  before_action :set_gitsha
  before_action :set_locale
  before_action :handle_mobile
  before_action :use_preferred_format

  # Comment out when use only ajax content for mobile version

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  private

  def mobile_user_agent?
    request.env["HTTP_USER_AGENT"].try :match, /(iphone|ipod|android)/i
  end

  def handle_mobile
    #request.format = :mobile if mobile_user_agent?
    # todo: uncomment if mobile format supported
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

  def set_gitsha
    headers['X-GitSHA'] = PhotoBlogApp::Application::GIT_SHA
  end
end