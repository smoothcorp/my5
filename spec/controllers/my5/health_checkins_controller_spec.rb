require 'spec_helper'

describe My5::HealthCheckinsController do

  def valid_attributes
    customer = subject.current_customer
    {:stress_rating => 5, :energy_rating => 6, :comfort_rating => 7, :customer_id => customer.id, :step => 2}
  end

  context "with a customer signed in" do
    login_customer

    describe "GET index" do
      it "assigns all health_checkins as @health_checkins" do
        health_checkin = HealthCheckin.create! valid_attributes
        get :index
        controller.health_checkins.should eq([health_checkin])
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new healthcheckin" do
          expect {
            post :create, :health_checkin => valid_attributes
          }.to change(HealthCheckin, :count).by(1)
        end

        it "assigns a newly created health_checkin as @health_checkin" do
          post :create, :health_checkin => valid_attributes
          controller.health_checkin.should be_a(HealthCheckin)
          controller.health_checkin.should be_persisted
        end

        it "redirects to the health checkin index" do
          post :create, :health_checkin => valid_attributes
          response.should redirect_to(my5_health_checkins_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved health_checkin as @health_checkin" do
          HealthCheckin.any_instance.stub(:save).and_return(false)
          post :create, :health_checkin => valid_attributes
          controller.health_checkin.should be_a_new(HealthCheckin)
        end

        it "re-renders the 'new' template" do
          HealthCheckin.any_instance.stub(:save).and_return(false)
          post :create, :health_checkin => valid_attributes
          response.should render_template("new")
        end
      end
    end

  end
end
