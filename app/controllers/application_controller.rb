class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :layout_by_resource
  before_filter :force_devise_ssl
  require 'spreadsheet'
  
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
    force_devise_ssl
  end
  
  def force_devise_ssl
    Rails.logger.debug "Deactivating SSL for #{params[:controller]}"
  end

  def set_customer_time_zone
    Time.zone = current_customer.time_zone if customer_signed_in?
  end

  def customer_views
      if params[:controller] == "my5/audio_programs"
       params[:video_id] = params[:audio_id]
     end
     current_customer.customer_visits.create(:controller_name => params[:controller], :action_name => params[:action], :conditions => params[:condition], :show_id => params[:id], :media_id => params[:video_id], :part=> params[:part])
  end

  def set_time_zone
    if @zones.count == 142
      own_time_zone_first = ActiveSupport::TimeZone.create('Sydney', +32_400)
      own_time_zone_second = ActiveSupport::TimeZone.create('Sydney', +39_600)
      @zones << own_time_zone_first
      @zones << own_time_zone_second
    end
  end
end
