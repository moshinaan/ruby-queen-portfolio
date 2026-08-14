class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  around_action :switch_locale

  private

  def switch_locale(&action)
    locale = params[:locale].presence || session[:locale] || I18n.default_locale
    locale = locale.to_sym
    locale = I18n.default_locale unless I18n.available_locales.include?(locale)
    session[:locale] = locale
    I18n.with_locale(locale, &action)
  end
end
