class CustomerSessionsController < Devise::SessionsController

  def new
    resource = build_resource
    clean_up_passwords(resource)
    respond_with_navigational(resource, stub_options(resource)){ render_with_scope :new }
    if params[:company_login]
      session[:company_login] = true
    end
  end

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    if session[:company_login]
      session[:company_login] = false
      if resource.role == "manager"
        resource_sign_in(resource)
      else
        sign_out
        flash[:alert] = "you dont manager"
        redirect_to root_path
      end
    else
      resource_sign_in(resource)
    end
  end

  def resource_sign_in(resource)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_with resource, :location => redirect_location(resource_name, resource)
  end

end
