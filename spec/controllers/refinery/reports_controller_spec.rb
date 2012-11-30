require 'spec_helper'

describe Refinery::ReportsController do

  context "with user logged in" do
    login_refinery_user

    describe "GET index" do
      it "renders view if logged in" do
        get :index
        response.should be_success
        response.should render_template :index
      end

      it "redirects to login if not logged in" do
        sign_out @refinery_user
        get :index
        response.should_not render_template :index
        response.should redirect_to(new_user_session_url)
      end
    end
  end

end
