class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource
  before_filter :force_devise_ssl
  
  def after_sign_in_path_for(resource)
      dashboard_url
  end

  def redirect_to_dashboard_if_signed_in
    if current_user && params[:action != "dashboard"]
      redirect_to dashboard_url
    end
  end

  def layout_by_resource
    if devise_controller? && resource_name == :customer && ((params[:action] == "edit" || params[:action] == "update") && params[:controller] != "devise/passwords")
      "customer"
    else
      "application"
    end
  end

  def active_subscription_for_customer!
    if customer_signed_in?
      unless current_customer.active?
        redirect_to new_subscription_url, :notice => 'You must have an active subscription to access My 5'
      end
    else
      opts = {:scope => :customer}
      warden.authenticate!(opts) if !devise_controller? || opts.delete(:force)
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_customer)
  end
  
  def force_ssl
    Rails.logger.debug "THE REQUEST IS: " + request.protocol.to_s
    if !request.ssl? && Rails.env == 'production'
      redirect_to "https://" + request.host + request.request_uri
      flash.keep
    end
  end
  
  def force_devise_ssl
    if params[:controller] && !request.ssl? && params[:controller].include?('devise') && Rails.env == 'production'
      redirect_to "https://" + request.host + request.request_uri
      flash.keep
    end
  end
end
