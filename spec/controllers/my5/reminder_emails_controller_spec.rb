require 'spec_helper'

describe My5::ReminderEmailsController do

  def valid_attributes
    {:days_of_week => "0,1", :time => Time.now}
  end

  def valid_post_attributes
    {"time(1i)"=>"1", "time(2i)"=>"1", "time(3i)"=>"1", "time(4i)"=>"05", "time(5i)"=>"00", "days_of_week_input"=>["", "0"]}
  end
  
  describe "user not logged in" do
    login_refinery_user
      
    it "redirects to the root page" do
      get :index
      response.should_not render_template("index")
      response.should redirect_to(new_customer_session_path)
    end
  end

  describe "GET index" do
    login_customer
    
    it "assigns reminder_email as @reminder_email if exists" do
      reminder_email = @customer.reminders.create(valid_attributes)
      get :index
      assigns(:reminder_emails).should eq([reminder_email])
    end
  end
  
  describe "GET new" do
    login_customer

    it "assigns a new reminder_email as @reminder_email" do
      get :new
      assigns(:reminder_email).should be_a_new(ReminderEmail)
    end
  end

  describe "GET edit" do
    login_customer

    it "assigns the requested reminder_email as @reminder_email" do
      reminder_email = @customer.reminders.create(valid_attributes)
      get :edit, :id => reminder_email.id.to_s
      assigns(:reminder_email).should eq(reminder_email)
    end
  end

  describe "POST create" do
    login_customer

    describe "with valid params" do
      it "creates a new ReminderEmail" do
        expect {
          post :create, :reminder_email => valid_post_attributes
        }.to change(ReminderEmail, :count).by(1)
      end

      it "assigns a newly created reminder_email as @reminder_email" do
        post :create, :reminder_email => valid_post_attributes
        assigns(:reminder_email).should be_a(ReminderEmail)
        assigns(:reminder_email).should be_persisted
      end

      it "redirects to the created reminder_email" do
        post :create, :reminder_email => valid_post_attributes
        response.should redirect_to(my5_reminder_emails_url)
      end

      it "assigns the current_customer to the new reminder_email" do
        post :create, :reminder_email => valid_post_attributes
        assigns(:reminder_email).customer_id.should eq(@customer.id)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reminder_email as @reminder_email" do
        ReminderEmail.any_instance.stub(:save).and_return(false)
        post :create, :reminder_email => valid_post_attributes
        assigns(:reminder_email).should be_a_new(ReminderEmail)
      end

      it "re-renders the 'new' template" do
        ReminderEmail.any_instance.stub(:save).and_return(false)
        post :create, :reminder_email => valid_post_attributes
        response.should render_template("index")
      end
    end
  end

  describe "PUT update" do
    login_customer

    describe "with valid params" do
      it "assigns the requested reminder_email as @reminder_email" do
        reminder_email = @customer.reminders.create(valid_attributes)
        put :update, :id => reminder_email.id, :reminder_email => valid_post_attributes
        assigns(:reminder_email).should eq(reminder_email)
      end

      it "redirects to the reminder_email" do
        reminder_email = @customer.reminders.create(valid_attributes)
        put :update, :id => reminder_email.id, :reminder_email => valid_post_attributes
        response.should redirect_to(my5_reminder_emails_url)
      end
    end

    describe "with invalid params" do
      it "assigns the reminder_email as @reminder_email" do
        reminder_email = @customer.reminders.create(valid_attributes)
        ReminderEmail.any_instance.stub(:save).and_return(false)
        put :update, :id => reminder_email.id.to_s, :reminder_email => valid_post_attributes
        assigns(:reminder_email).should eq(reminder_email)
      end

      it "re-renders the 'edit' template" do
        reminder_email = @customer.reminders.create(valid_attributes)
        ReminderEmail.any_instance.stub(:save).and_return(false)
        put :update, :id => reminder_email.id.to_s, :reminder_email => valid_post_attributes
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_customer

    it "destroys the requested reminder_email" do
      reminder_email = @customer.reminders.create valid_attributes
      expect {
        delete :destroy, :id => reminder_email.id.to_s
      }.to change(ReminderEmail, :count).by(-1)
    end

    it "redirects to the reminder_emails list" do
      reminder_email = @customer.reminders.create valid_attributes
      delete :destroy, :id => reminder_email.id.to_s
      response.should redirect_to(my5_reminder_emails_url)
    end
  end

end
