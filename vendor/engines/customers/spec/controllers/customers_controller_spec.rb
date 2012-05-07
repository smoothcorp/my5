require "spec_helper"

describe CustomersController do
  login_refinery_user
  
  def create_customers
    @corporation1 = Factory.create(:corporation)
    @corporation2 = Factory.create(:corporation)
    @department1 = Factory.create(:department, :corporation => @corporation1)
    @department2 = Factory.create(:department, :corporation => @corporation1)
    
    # Set Manager
    @manager = Factory.create(:customer)
    @manager.update_attribute(:corporation_id, @corporation1.id)
    @manager.update_attribute(:role, "manager")
    
    # Set Department Manager
    @dept_manager = Factory.create(:customer)
    @dept_manager.update_attribute(:corporation_id, @corporation1.id)
    @dept_manager.update_attribute(:department_id, @department1.id)
    @dept_manager.update_attribute(:role, "dept_manager")
    
    # Create some users that belong to the Manager's corporation
    @customer_two = Factory.create(:customer)
    @customer_two.update_attribute(:corporation_id, @corporation1.id)
    @customer_three = Factory.create(:customer)
    @customer_three.update_attribute(:corporation_id, @corporation1.id)
    
    # Create some users that don't belong to the Manager's corporation
    @customer_four = Factory.create(:customer)
    @customer_four.update_attribute(:corporation_id, @corporation2.id)
    
    # Create some users that belong to the Department Manager's department
    @customer_five = Factory.create(:customer)
    @customer_five.update_attribute(:corporation_id, @corporation1.id)
    @customer_five.update_attribute(:department_id, @department1.id)
    
    # Create some users that don't belong to the Department Manager's department
    @customer_six = Factory.create(:customer)
    @customer_six.update_attribute(:corporation_id, @corporation1.id)
    @customer_six.update_attribute(:department_id, @department2.id)
  end
  
  def valid_attributes
    {:first_name => "Chris", :last_name => "Test", :email => "get@out.com"}
  end


  ## --- GET Index
  describe "GET index" do
    describe "without manager or dept_manager role" do
      login_customer
      
      after(:each) do
        sign_out(@customer)
      end
      
      it "blocks access if not a manager or dept_manager" do
        expect {
          get :index
        }.to raise_error(CanCan::AccessDenied)
      end
    end
    
    describe "with manager role" do
      before(:each) do
        create_customers
        sign_in @manager
      end
      
      after(:each) do
        sign_out(@manager)
      end
      
      it "assigns customers to @customers" do
        get :index
        assigns(:customers).should eq([@dept_manager, @customer_two, @customer_three, @customer_five, @customer_six])
      end
      
      it "only assigns customers in their corporation to @customers" do
        get :index
        assigns(:customers).include?(@customer_four).should eq(false)
      end
    end
    
    describe "with dept manager role" do
      before(:each) do
        create_customers
        sign_in @dept_manager
      end
      
      it "assigns customers to @customers" do
        get :index
        assigns(:customers).should eq([@customer_five])
      end
      
      it "only assigns customers in their department to @customers" do
        get :index
        assigns(:customers).include?(@customer_six).should eq(false)
      end
    end
  end
  
  
  ## --- POST Create
  describe "POST create" do
    describe "without manager role" do
      login_customer
      
      after(:each) do
        sign_out(@customer)
      end
      
      it "blocks access if not a manager or dept_manager" do
        expect {
          post :create_corp_customer, :customer => valid_attributes
        }.to raise_error(CanCan::AccessDenied)
      end
    end
    
    describe "with manager role" do
      before(:each) do
        create_customers
        sign_in @manager
      end
      
      it "saves customer" do
        expect {
          post :create_corp_customer, :customer => valid_attributes
        }.to change(Customer, :count).by(1)
      end
      
      it "saves customer with correct corporation" do
        post :create_corp_customer, :customer => valid_attributes
        Customer.last.corporation_id.should eq(@corporation1.id)
      end
      
      it "sends an email with new password" do
        expect{
          post :create_corp_customer, :customer => valid_attributes
        }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end 
      
      it "sends password email" do
        post :create_corp_customer, :customer => valid_attributes
        ActionMailer::Base.deliveries.last.subject.should eq("Welcome to My 5!")
      end
    end
    
    describe "with dept manager role" do
      before(:each) do
        create_customers
        sign_in @dept_manager
      end
      
      it "saves customer" do
        expect {
          post :create_corp_customer, :customer => valid_attributes
        }.to change(Customer, :count).by(1)
      end
      
      it "saves customer with correct department" do
        post :create_corp_customer, :customer => valid_attributes
        Customer.last.department_id.should eq(@dept_manager.department.id)
      end
      
      it "sends an email with new password" do
        expect{
          post :create_corp_customer, :customer => valid_attributes
        }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end 
      
      it "sends password email" do
        post :create_corp_customer, :customer => valid_attributes
        ActionMailer::Base.deliveries.last.subject.should eq("Welcome to My 5!")
      end
    end
  end
  
  
  ## --- GET Edit
  describe "GET edit" do
    describe "without manager role" do
      login_customer
      
      after(:each) do
        sign_out(@customer)
      end
      
      it "blocks access if not a manager or dept_manager" do
        @customer_two = Factory.create(:customer)
        @customer_two.update_attribute(:corporation_id, Factory.create(:corporation))
        expect {
          get :edit, :id => @customer_two.id
        }.to raise_error(CanCan::AccessDenied)
      end
    end
    
    describe "with manager role" do
      before(:each) do
        create_customers
        sign_in @manager
      end
      
      it "assigns correct customer" do
        get :edit, :id => @customer_two.id
        assigns(:customer).should eq(@customer_two)
      end
      
      it "errors out if try to access customer from another corporation" do
        expect {
          get :edit, :id => @customer_four.id
        }.to raise_error(CanCan::AccessDenied)
      end
    end
    
    describe "with dept manager role" do
      before(:each) do
        create_customers
        sign_in @dept_manager
      end
      
      it "assigns correct customer" do
        get :edit, :id => @customer_five.id
        assigns(:customer).should eq(@customer_five)
      end
      
      it "errors out if try to access customer from another department" do
        expect {
          get :edit, :id => @customer_six.id
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
  
  
  ## --- PUT Update
  describe "PUT update" do
    describe "without manager role" do
      login_customer
      
      after(:each) do
        sign_out(@customer)
      end
      
      it "blocks access if not a manager or dept_manager" do
        @customer_two = Factory.create(:customer)
        @customer_two.update_attribute(:corporation_id, Factory.create(:corporation))
        expect {
          put :update_corp_customer, :id => @customer_two.id, :customer => {:first_name => "Jeffrey"}
        }.to raise_error(CanCan::AccessDenied)
      end
    end
    
    describe "with manager role" do
      before(:each) do
        create_customers
        sign_in @manager
      end
      
      it "updates customer" do
        put :update_corp_customer, :id => @customer_two.id, :customer => {:first_name => "Jeffrey"}
        Customer.find(@customer_two.id).first_name.should eq("Jeffrey")
      end
      
      it "errors out when tries to update customer from another corporation" do
        expect {
          put :update_corp_customer, :id => @customer_four.id, :customer => {:first_name => "Jeffrey"}
        }.to raise_error(CanCan::AccessDenied)
      end
    end
    
    describe "with dept manager role" do
      before(:each) do
        create_customers
        sign_in @dept_manager
      end
      
      it "updates customer" do
        put :update_corp_customer, :id => @customer_five.id, :customer => {:first_name => "Jeffrey"}
        Customer.find(@customer_five.id).first_name.should eq("Jeffrey")
      end
      
      it "errors out when tries to update customer from another department" do
        expect {
          put :update_corp_customer, :id => @customer_six.id, :customer => {:first_name => "Jeffrey"}
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
  
end
