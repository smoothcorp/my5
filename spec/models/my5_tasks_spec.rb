require 'spec_helper'
require 'my5_tasks'

describe My5Tasks do
  describe "#renew_expired_subscriptions" do

    before(:each) do
      @customer = Factory.create(:customer)
      @subscription = Factory.create(:subscription)
      @customer.subscriptions << @subscription
    end

    it "does not renew any subscription that are still valid" do
      @customer = Customer.find(@customer.id)
      @customer.update_attribute(:renew_subscription, true)
      @customer.subscriptions.first.update_attribute(:expiry_date, Time.now + 1.days)

      Customer.any_instance.should_not_receive(:process_payment_for_subscription)

      obj = My5Tasks.new
      obj.renew_expired_subscriptions
    end

    it "does not renew any subscription where the customer has specified that they do not want to renew their subscription" do
      @customer = Customer.find(@customer.id)
      @customer.update_attribute(:renew_subscription, false)
      @customer.subscriptions.first.update_attribute(:expiry_date, Time.now - 6.hours)

      Customer.any_instance.should_not_receive(:process_payment_for_subscription)

      obj = My5Tasks.new
      obj.renew_expired_subscriptions
    end

    it "does renew a subscription where the current subscription has expired" do
      @customer = Customer.find(@customer.id)
      @customer.update_attribute(:renew_subscription, true)
      @customer.subscriptions.first.update_attribute(:expiry_date, Time.now - 6.hours)

      Customer.any_instance.should_receive(:process_payment_for_subscription)

      obj = My5Tasks.new
      obj.renew_expired_subscriptions
    end
  end
  
  describe "#remind_expiring_free_trials" do
    
    before(:each) do
      @customer = Factory.create(:customer)
      @subscription = Factory.create(:subscription)
      @customer.subscriptions << @subscription
    end
    
    describe "with expiring subscription" do
      before(:each) do
        @subscription.update_attribute(:status, 2)
        ActionMailer::Base.deliveries = []
      end
      
      it "increases the mail queue by one" do
        Timecop.freeze(Time.now) do
          @subscription.update_attribute(:expiry_date, (Time.now + 1.5.days))
          expect {
            obj = My5Tasks.new
            obj.remind_expiring_free_trials
          }.to change(ActionMailer::Base.deliveries, :size).by(1)
        end
      end
    
      it "sends an email with the correct subject" do
        Timecop.freeze(Time.now) do
          @subscription.update_attribute(:expiry_date, (Time.now + 1.5.days))
          obj = My5Tasks.new
          obj.remind_expiring_free_trials
          ActionMailer::Base.deliveries.first.subject.should eq("Your My 5 Trial")
        end
      end
    end
    
    describe "without expiring subscription" do
      it "does not increase the mail queue by one if a user does not have an expiring subscription" do
        Timecop.freeze(Time.now) do
          @subscription.update_attribute(:expiry_date, (Time.now + 0.8.days))
          expect {
            obj = My5Tasks.new
            obj.remind_expiring_free_trials
          }.to change(ActionMailer::Base.deliveries, :size).by(0)
        end
      end
    end
    
  end
end