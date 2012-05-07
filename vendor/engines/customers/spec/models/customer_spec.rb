require 'spec_helper'

describe Customer do

  before(:each) do
    @corporation = Factory.create(:corporation)
    @customer = Factory.create(:customer)
    @new_customer = Customer.new(valid_attributes)
  end

  after(:each) do
    @new_customer = nil
  end

  def valid_attributes
    {:title => "Mr.", :first_name => "Firstname", :last_name => "Lastname", :email => "a@b.com", :password => "password", :street_1 => "123 ABC St", :city => "Sydney", :state => "NSW", :country => "AU", :zip_code => "1234"}
  end


  ## -----------
  ## -- Basic tests of validations
  ## -----------
  context "create" do
    it "should be valid" do
      @new_customer.should be_valid
    end

    it "sholud not be valid" do
      @new_customer.first_name = nil
      @new_customer.should_not be_valid
    end

    it "should not be valid if role is 'dept_manager' without a department_id" do
      @new_customer.role = "dept_manager"
      @new_customer.should_not be_valid
    end

    it "should not be valid if role is 'manager' without a corporation_id" do
      @new_customer.role = "manager"
      @new_customer.should_not be_valid
    end

    it "should not be valid if role assigned department and no corporation" do
      @department = Factory.create(:department, :corporation => @corporation)
      @new_customer.department = @department
      @new_customer.should_not be_valid
    end

    it "should not be valid if assign department ID of another corporation" do

    end
  end


  ## -----------
  ## -- Test of updating the model and validations
  ## -----------
  context "update" do
    it "should save model with updated attribute without errors" do
      @customer.first_name = "FirstnameAltered"
      @customer.save
      @customer.errors.should be_blank
    end

    it "should update_attributes without errors" do
      @customer.update_attributes(:customer => {:first_name => "FirstnameAltered"})
      @customer.errors.should be_blank
    end
  end


  ## -----------
  ## -- Test time for event models
  ## -----------
  describe "#time_for_event_with_title_since" do
    it "returns time in text format if there are occurences" do
      @event = Factory.create(:event)
      # Generate some occurences for the DB
      expect {
        occurences = (1..5).inject([]) do |a, i|
          a << Factory.create(:occurence, :event => @event, :customer => @new_customer)
        end
      }.to change(@new_customer.occurences, :count).by(5)

      # We know the difference between the first and last occurence is four hours as
      # they are always 1 hour appart (per factory)
      @new_customer.time_for_event_with_title_since(@event.title, Occurence.last.created_at - 5.hours).should eq("04:00:00")
    end

    it "returns time only within the timeframe" do
      @event = Factory.create(:event)
      # Generate some occurences for the DB
      expect {
        occurences = (1..5).inject([]) do |a, i|
          a << Factory.create(:occurence, :event => @event, :customer => @new_customer)
        end
      }.to change(@new_customer.occurences, :count).by(5)

      # We know the difference between the first and last occurence as
      # they are always 1 hour appart (per the factory)
      @new_customer.time_for_event_with_title_since(@event.title, @new_customer.occurences.all.last.created_at + 2.5.hours).should eq("01:00:00")
    end

    it "doubles with second session" do
      @event = Factory.create(:event)
      expect {
        occurences = (1..5).inject([]) do |a, i|
          a << Factory.create(:occurence, :event => @event, :customer => @new_customer)
        end
      }.to change(@new_customer.occurences, :count).by(5)
      expect {
        occurences = (1..5).inject([]) do |a, i|
          a << Factory.create(:occurence_alt_session, :event => @event, :customer => @new_customer)
        end
      }.to change(@new_customer.occurences, :count).by(5)

      @new_customer.time_for_event_with_title_since(@event.title, (@new_customer.occurences.count + 1).hours).should eq("08:00:00")
    end

    it "returns 0 if there are no occurences for this user" do
      @occurence = Factory.create(:occurence, :event => @event, :customer => @customer)
      @customer.time_for_event_with_title_since("event_title", Date.today - 6.days)
    end

    it "returns false if can't find event" do
      @new_customer.time_for_event_with_title_since("This doesn't exist", Date.today - 6.days).should eq(false)
    end
  end


  ## -----------
  ## -- Test utility methods
  ## -----------
  describe "#last_session_id" do
    it "returns last session id if present" do
      @event = Factory.create(:event)
      Factory.create(:occurence, :event => @event, :customer => @customer)
      Factory.create(:occurence_alt_session, :event => @event, :customer => @customer)
      @customer.last_session_id.should eq("5678")
    end

    it "returns false if no occurences" do
      @customer.last_session_id.should eq(false)
    end
  end
  
  describe "#save_without_password" do
    it "should save to database" do
      @customer_with_no_pw = Customer.new(valid_attributes.merge!(:password => "", :password_confirmation => ""))
      expect{
        @customer_with_no_pw.save_without_password
      }.to change(Customer, :count).by(1)
    end
    
    it "should return password" do
      Devise.stub!(:friendly_token).and_return("123456789")
      @customer_with_no_pw = Customer.new(valid_attributes.merge!(:password => "", :password_confirmation => ""))
      @password = @customer_with_no_pw.save_without_password
      @password.should eq("12345678")
    end
    
    it "should not save if invalid" do
      @customer_with_no_pw = Customer.new(valid_attributes.merge!(:password => "", :password_confirmation => "", :first_name => ""))
      expect{
        @customer_with_no_pw.save_without_password
      }.to change(Customer, :count).by(0)
    end
    
    it "should return errors if invalid" do
      @customer_with_no_pw = Customer.new(valid_attributes.merge!(:password => "", :password_confirmation => "", :first_name => ""))
      @customer_with_no_pw.save_without_password
      @customer_with_no_pw.errors.should_not be_empty
    end
  end


  ## -----------
  ## -- Test login time and duration methods
  ## -----------
  describe "#last_login_duration" do
    it "returns 0 if no occurences (no last session id)" do
      @customer.stub!(:last_session_id).and_return(false)
      @customer.last_login_duration.should eq(0)
    end

    it "returns result if occurences exist" do
      @event = Factory.create(:event)
      # Generate some occurences for the DB
      expect {
        occurences = (1..5).inject([]) do |a, i|
          a << Factory.create(:occurence, :event => @event, :customer => @customer)
        end
      }.to change(@customer.occurences, :count).by(5)

      @customer.last_login_duration.should eq("04:00:00")
    end
  end

  describe "#login_time_since_raw_seconds" do
    it "returns 0 if no occurences" do
      @customer.login_time_since_raw_seconds(Time.now - 6.days).should eq(0)
    end

    it "returns false if there are occurences with nil session id" do

    end

    it "returns correct seconds value if occurences exist" do
      @event = Factory.create(:event)
      # Generate some occurences for the DB
      expect {
        occurences = (1..5).inject([]) do |a, i|
          a << Factory.create(:occurence, :event => @event, :customer => @customer)
          a << Factory.create(:occurence_alt_session, :event => @event, :customer => @customer)
        end
      }.to change(@customer.occurences, :count).by(10)

      @customer.login_time_since_raw_seconds(Time.now - (Occurence.count + 4).hours).ceil.should eq(14400)
    end
  end

  describe "#login_time_on_raw_seconds" do
    it "returns 0 if no occurences" do
      @customer.login_time_since_raw_seconds(Time.now - 6.days).should eq(0)
    end

    it "returns correct seconds value if occurences exist" do
      @event = Factory.create(:event)
      # Generate some occurences for the DB
      expect {
        occurences = (1..5).inject([]) do |a, i|
          a << Factory.create(:occurence_half_days_apart, :event => @event, :customer => @customer)
        end
      }.to change(@customer.occurences, :count).by(5)

      @customer.login_time_on_raw_seconds(@event.occurences.last.created_at + 24.hours).ceil.should eq(43200)
    end
  end

  ## -----------
  ## -- Test the payments methods
  ## -----------
  describe "#store_eway_customer" do
    valid_credit_card = { :card_number => "1234123412341234", :expiry_month => "01", :expiry_year => "2011", :verification => "123", :name_on_card => "Test McTest" }

    it "returns nil when providing an invalid credit card" do
      result = @customer.store_eway_customer({})
      result.should be_false
    end

    it "returns a string representing an eWay customer when provided a valid Customer and credit card" do
      @cc_mock = mock(ActiveMerchant::Billing::CreditCard)
      @cc_mock.stub!(:valid?).and_return(true)
      @cc_mock.stub!(:display_number).and_return("XXXX-XXXX-XXXX-1234")
      @cc_mock.stub!(:expiry_date).and_return(Date.today + 2.years)
      @cc_mock.stub!(:name).and_return("John Smith")
      ActiveMerchantHelper.stub!(:credit_card_from_details).and_return(@cc_mock)


      @response = mock(ActiveMerchant::Billing::Response)
      @response.stub!(:success?).and_return(true)
      @response.stub!(:token).and_return("ABCD1234")

      @gateway_mock = mock(ActiveMerchant::Billing::EwayManagedGateway)
      @gateway_mock.stub!(:store).and_return(@response)

      ActiveMerchant::Billing::EwayManagedGateway.stub!(:new).and_return(@gateway_mock)

      result = @customer.store_eway_customer(valid_credit_card)
      result.kind_of?(String).should be_true
      @customer.eway_token.should == result
    end

    it "populates Customer card_number and card_expiry_date when provided a valid Customer and credit card" do
      @customer.update_attribute(:card_number, nil)
      @customer.update_attribute(:card_expiry_date, nil)

      @cc_mock = mock(ActiveMerchant::Billing::CreditCard)
      @cc_mock.stub!(:valid?).and_return(true)
      @cc_mock.stub!(:display_number).and_return("XXXX-XXXX-XXXX-1234")
      @cc_mock.stub!(:expiry_date).and_return(Date.today + 2.years)
      @cc_mock.stub!(:name).and_return("John Smith")
      ActiveMerchantHelper.stub!(:credit_card_from_details).and_return(@cc_mock)


      @response = mock(ActiveMerchant::Billing::Response)
      @response.stub!(:success?).and_return(true)
      @response.stub!(:token).and_return("ABCD1234")

      @gateway_mock = mock(ActiveMerchant::Billing::EwayManagedGateway)
      @gateway_mock.stub!(:store).and_return(@response)

      ActiveMerchant::Billing::EwayManagedGateway.stub!(:new).and_return(@gateway_mock)

      @customer.card_number.should be_nil
      @customer.card_expiry_date.should be_nil

      result = @customer.store_eway_customer(valid_credit_card)

      result.should_not be_false
      @customer.card_number.should == "XXXX-XXXX-XXXX-1234"
      @customer.card_expiry_date.should == "#{(Date.today + 2.years).month}/#{(Date.today + 2.years).year}"
    end
  end

  describe "#validate_credit_card" do
    valid_credit_card = { :card_number => "1234123412341234", :expiry_month => "01", :expiry_year => "2011", :verification => "123", :name_on_card => "Test McTest" }

    it "returns false for and invalid credit card" do
      Customer.validate_credit_card({}).should be_false
    end

    it "returns true for a valid credit card" do
      Customer.validate_credit_card(valid_credit_card).should be_true
    end
  end

  describe "#billing_address" do
    it "returns a hash with the keys :address1, :phone, :zip, :city, :country, :state, :mobile, :fax" do
      @customer.billing_address.keys.should == [:title, :address1, :phone, :zip, :city, :country, :state, :mobile, :fax]
    end

    it "returns a hash in active_merchant readable format" do
      @customer.street_1 = "1 Test Way"
      expected_result = {
        :title    => "Mr.",
        :address1 => "1 Test Way",
        :city     => "Test Town",
        :state    => "NSW",
        :zip      => "2000",
        :country  => "AU",
        :phone    => "",
        :mobile   => "",
        :fax      => ""
      }
      @customer.billing_address.should == expected_result
    end
  end

  describe "#process_payment_for_subscription" do
    it "creates a new yearly subscription when a previous subscription isn't provided" do
      Payment.any_instance.stub(:can_process?).and_return(true)
      Payment.any_instance.stub(:process).and_return(true)

      @customer.subscriptions.active_subscription.should be_empty
      @customer.process_payment_for_subscription
      @customer.subscriptions.active_subscription.should_not be_empty
    end

    it "creates a new yearly subscription with an expiry date of 1 year on from a previous subscription when a previous subscription is provided" do
      Payment.any_instance.stub(:can_process?).and_return(true)
      Payment.any_instance.stub(:process).and_return(true)

      s = Subscription.yearly_subscription_for(@customer.id)
      @customer.subscriptions << s
      @customer.subscriptions.count.should == 1

      @customer.process_payment_for_subscription(@customer.subscriptions.active_subscription.first)

      @customer.subscriptions.count.should == 2
      @customer.subscriptions.last.expiry_date.should == s.expiry_date + 1.year
    end
  end
end