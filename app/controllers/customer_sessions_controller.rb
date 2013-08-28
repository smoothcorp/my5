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
      if resource.can_view_reports? && resource.role == 'manager'
        session[:manager_view] = true
        resource_sign_in(resource)
      else
        sign_out
        flash[:alert] = 'Only company manager can access this section.'
        redirect_to root_path
      end
    else
      session[:manager_view] = false
      resource_sign_in(resource)
    end
  end

  def destroy
    signed_in = signed_in?(resource_name)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    flash[:notice] = 'Signed out successfully.'
    respond_to do |format|
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
      format.all do
        method = "to_#{request_format}"
        text = {}.respond_to?(method) ? {}.send(method) : ""
        render :text => text, :status => :ok
      end
    end
  end

  def resource_sign_in(resource)
    flash[:notice] = 'Signed in successfully.'
    sign_in(resource_name, resource)
    if session[:manager_view]
      redirect_to my5_dashboard_reports_path
    else
      respond_with resource, :location => redirect_location(resource_name, resource)
    end
  end

end
