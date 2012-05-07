module Admin
  class CustomersController < Admin::BaseController
    crudify :customer, :title_attribute => 'first_name', :xhr_paging => true

    def index
      unless searching?
        @customers = Customer.order(set_order).paginate(:page => params[:page], :per_page => 30)
      else
        search_all_customers
        @customers = @customers.paginate(:page => params[:page], :per_page => 30)
      end

      render :partial => 'customers' if request.xhr?
    end

    def set_order
      if params["sort"] == "customer_type"
        "corporation_id ASC"
      elsif params["sort"] == "customer_name"
        "first_name ASC"
      elsif params["sort"] == "customer_signup"
        "created_at ASC"
      else
        "position ASC"
      end
    end

    def new
      @customer = Customer.new
    end

    def get_departments
      @departments = Department.where(:corporation_id => params[:id])
    end

    def create
      set_corporation
      @customer = Customer.new(params[:customer])

      if @customer.password.blank? and @customer.password_confirmation.blank?
        @password = @customer.save_without_password
        if @customer.save
          EmployeePasswordMailer.new_password(@customer, @password).deliver
          redirect_to admin_customers_url
        else
          render :action => 'new'
        end
      else
        if @customer.save
          redirect_to admin_customers_url
        else
          render :action => 'new'
        end
      end
    end

    def update
      set_corporation
      clean_up_passwords

      if @customer.update_attributes(params[:customer])
        redirect_to admin_customers_url
      else
        render :action => 'edit'
      end
    end

    private
      def set_corporation
        return unless params[:customer][:corporation]

        if params[:customer][:corporation].to_i == 0
          params[:customer][:corporation] = nil
        else
          params[:customer][:corporation] = Corporation.find(params[:customer][:corporation].to_i)
        end
      end

      def clean_up_passwords
        return unless params[:customer][:password] || params[:customer][:password_confirmation]

        if params[:customer][:password].blank?
          params[:customer].delete :password
          params[:customer].delete :password_confirmation
        end
      end

  end
end
