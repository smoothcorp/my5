class My5::DepartmentsController < ApplicationController
  before_filter :authenticate_customer!
  load_and_authorize_resource
  layout "customer"
  
  def index
    @departments = current_customer.corporation.departments.all
  end
  
  def new
    @department = current_customer.corporation.departments.build
  end
  
  def create
    @department = current_customer.corporation.departments.build(params[:department])
    
    if @department.save
      redirect_to my5_departments_path, :notice => "The department #{@department.name} was successfully created."
    else
      render "new"
    end
  end
  
  def edit
    @department = current_customer.corporation.departments.find(params[:id])
  end
  
  def update
    @department = current_customer.corporation.departments.find(params[:id])
    
    if @department.update_attributes(params[:department])
      redirect_to my5_departments_path, :notice => "The department #{@department.name} was successfully updated."
    else
      render "edit"
    end
  end
  
  def destroy
    @department = current_customer.corporation.departments.find(params[:id])
    if @department.customers.blank?
      redirect_to my5_departments_path, :notice => "You cannot delete #{@department.name} as it has active employees."
    else
      name = @department.name
      @department.delete
      redirect_to my5_departments_path, :notice => "#{name} was successfully deleted."
    end
  end
  
end
