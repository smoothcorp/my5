require 'spec_helper'

describe CustomerRegistrationsController do
  context "with a signed in customer" do
    login_customer

    describe "GET edit" do
      it "should respond with success" do
        @request.env["devise.mapping"] = Devise.mappings[:customer]
        get :edit
        response.status.should == 200
      end

      it "should render edit template" do
        @request.env["devise.mapping"] = Devise.mappings[:customer]
        get :edit
        response.should render_template("edit")
      end
    end

    describe "PUT update" do
      it "updates self without current password" do
        @request.env["devise.mapping"] = Devise.mappings[:customer]
        put :update, :id => @customer.id,:customer => {:last_name => "Smith"}
        response.should redirect_to(dashboard_url)
      end
      
      it "does not update self with new password yet without current password" do
        @request.env["devise.mapping"] = Devise.mappings[:customer]
        put :update, :id => @customer.id,:customer => {:password => "itwillbreak"}
        response.should render_template("edit")
      end
    end
  
  end
end
