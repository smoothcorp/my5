class CustomerRegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_customer!, :only => [:upload_image]
  before_filter :force_ssl
  before_filter :set_zone_variable

  def new
    if session[:new_customer] && session[:new_customer].any?
      session[:new_customer].delete(:credit_card)
      session[:new_customer].delete(:password)
      session[:new_customer].delete(:password_confirmation)

      self.resource = Customer.new(session[:new_customer])
    elsif self.resource.nil?
      self.resource = Customer.new
    end
  end

  def confirm_details
    session[:new_customer] = params[:customer]
    self.resource = Customer.new(session[:new_customer])

    # To populate all error fields
    is_valid = self.resource.valid?
    is_valid = self.resource.validate_credit_card_information(params[:customer][:credit_card]) && is_valid

    if is_valid
      @customer_details = session[:new_customer]
    else
      render :new
    end
  end

  def create
    credit_card = session[:new_customer].delete(:credit_card)
    self.resource = Customer.new(session[:new_customer])

    if self.resource.valid? # !credit_card.blank? && 
      if self.resource.store_eway_customer(credit_card) && resource.save
        session.delete(:new_customer)

        if resource.active_for_authentication?
          if self.resource.free_trial_opted?
            Subscription.free_trial_for(resource.id, 10.days).save
            SubscriptionsMailer.joined(self.resource).deliver
          else
            self.resource.process_payment
          end

          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_in(resource_name, resource)

          respond_with resource, :location => customer_confirmed_sign_up_url #after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
          expire_session_data_after_sign_in!

          respond_with resource, :location => customer_confirmed_sign_up_url #after_inactive_sign_up_path_for(resource)
        end
      else
        flash[:alert] = "There was an error processing your credit card details, please try again."
        clean_up_passwords(resource)
        respond_with_navigational(resource) { render_with_scope :new }
      end
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render_with_scope :new }
    end
  end

  def confirmed_sign_up
    render :layout => "customer"
  end

  def upload_image
    unless params[:customer] && current_customer.update_attributes(params[:customer]) && current_customer.save(:validate => false)
        @error = true
    end
    redirect_to :action => "edit"
  end

  def edit_billing_details
    render :layout => "customer"
  end

  def update_billing_details
    credit_card = params[:customer].delete(:credit_card)
    if current_customer.update_attributes(params[:customer]) && current_customer.store_eway_customer(credit_card) && current_customer.save
      redirect_to edit_customer_registration_path, :notice => 'Billing details updated!'
    else
      render :action => 'edit_billing_details', :alert => 'Unable to store your billing details'
    end
  end

  def remove_billing_details
    customer = current_customer

    customer.eway_token = customer.street_1 = customer.street_2 = customer.city = customer.state = customer.country = customer.zip_code = customer.card_number = customer.card_expiry_date = nil

    if customer.save
      redirect_to edit_customer_registration_path, :notice => 'Billing details removed!'
    else
      redirect_to edit_customer_registration_path, :alert => 'Unable to remove billing details.'
    end

  end


  private 
    def set_zone_variable
      @zones = ActiveSupport::TimeZone.all
      set_time_zone
    end
end
