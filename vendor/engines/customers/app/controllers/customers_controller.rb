class CustomersController < ApplicationController
  before_filter :authenticate_customer!
  load_and_authorize_resource
  layout "customer", :only => [:index, :new, :create_corp_customer, :edit, :update_corp_customer]
  
  def index
    if current_customer.manager?
      @customers = current_customer.corporation.customers.all - [current_customer]
    elsif current_customer.dept_manager?
      @customers = current_customer.department.customers.all - [current_customer]
    end 
  end

  def new
    if current_customer.manager?
      @customer = current_customer.corporation.customers.build
    elsif current_customer.dept_manager?
      @customer = current_customer.department.customers.build
    end
  end
  
  def create_corp_customer
    if current_customer.manager?
      @customer = current_customer.corporation.customers.build(params[:customer])
    elsif current_customer.dept_manager?
      @customer = current_customer.corporation.customers.build(params[:customer])
      @customer.department = current_customer.department
    end
    
    # password_length = 8
    # @password = Devise.friendly_token.first(password_length)
    # @customer.password = @password
    # @customer.password_confirmation = @password
    @password = @customer.save_without_password
    if @customer.save
      EmployeePasswordMailer.new_password(@customer, @password).deliver
      redirect_to customers_path
    else
      render "new"
    end
  end
  
  def edit
    if current_customer.manager?
      @customer = current_customer.corporation.customers.find(params[:id])
    elsif
      @customer = current_customer.department.customers.find(params[:id])
    end
  end
  
  def update_corp_customer
    if current_customer.manager?
      @customer = current_customer.corporation.customers.find(params[:id])
    elsif
      @customer = current_customer.department.customers.find(params[:id])
    end
    
    if @customer.update_attributes(params[:customer])
      redirect_to customers_path
    else
      render "new"
    end
  end
end
