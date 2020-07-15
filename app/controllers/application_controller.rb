class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_cart
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  include CanCan::ControllerAdditions
  include SessionsHelper
  rescue_from ActiveRecord::RecordNotFound, with: :active_record_record_not_found
  rescue_from CanCan::AccessDenied, with: :cancan_access_denied

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def cancan_access_denied
    flash[:danger] = t "application.text_denied"
    redirect_to root_url
  end

  def active_record_record_not_found
    flash[:danger] = t "application.text_error_resource"
    redirect_to root_url
  end

  def default_url_options
    {locale: I18n.locale}
  end

  private

  def set_cart
    session[:cart] ||= {}
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def current_ability
    controller_name_segments = params[:controller].split('/')
    controller_name_segments.pop
    controller_namespace = controller_name_segments.join('/').camelize
    @current_ability ||= Ability.new(current_user, controller_namespace)
  end
end
