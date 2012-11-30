require 'spec_helper'

describe Admin::CustomersController do

  context "with user logged in" do
    login_refinery_user

    before (:each) do
      @customer = Factory.create(:customer)
      @new_customer = Customer.new(valid_attributes)
    end
    
    after(:each) do
      @customer = nil
      @new_customer = nil
    end

    def valid_attributes
      {:title => "Mr.", :first_name => "Firstname", :last_name => "Lastname", :email => "a@b.com", :password => "password", :street_1 => "123 ABC St", :city => "Sydney", :state => "NSW", :country => "AU", :zip_code => "1234"}
    end
  
    describe "GET new" do
      it "assigns customer" do
        get :new
        response.should be_success
        response.should render_template :new
        assigns(:customer).should be_a(Customer)
      end
    end

    describe "POST create" do
      it "creates a customer" do
        expect{
          post :create, :customer => valid_attributes
        }.to change(Customer, :count).by(1)
      end
      
      it "does not create a customer with invalid attributes" do
        expect{
          post :create, :customer => valid_attributes.merge!(:first_name => "")
        }.to change(Customer, :count).by(0)
      end
      
      it "does not send an email if the password is not blank" do
        expect{
          post :create, :customer => valid_attributes
        }.to change(ActionMailer::Base.deliveries, :size).by(0)
      end
      
      it "sends an email if the password is blank" do
        expect{
          post :create, :customer => valid_attributes.merge!(:password => "", :password_confirmation => "")
        }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end 
      
      it "sends password email" do
        post :create, :customer => valid_attributes.merge!(:password => "", :password_confirmation => "")
        ActionMailer::Base.deliveries.last.subject.should eq("Welcome to My 5!")
      end
    end
    
    describe "PUT update" do
      it "updates customer with blank password" do
        put :update, :id => @customer.id, :customer => {:first_name => "FirstnameAltered", :password => "", :password_confirmation => ""}
        response.should redirect_to(admin_customers_path)
        Customer.find(@customer.id).first_name.should eq("FirstnameAltered")
      end
    end

  end
end
