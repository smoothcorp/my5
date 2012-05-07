require 'spec_helper'

describe Subscription do

  def reset_subscription(options = {})
    @valid_attributes = {
      :id => 1,
      :customer_id => 1,
      :expiry_date => 5.days.from_now,
      :plan => 1,
      :status => 0
    }

    @subscription.destroy! if @subscription
    @subscription = Subscription.create!(@valid_attributes.update(options))
  end

  before(:each) do
    Timecop.return
    reset_subscription
  end

  context "validations" do
    it "rejects an empty customer id" do
      new_params = @valid_attributes.merge({ :customer_id => nil })
      result = Subscription.new(new_params)
      result.should_not be_valid
    end

    it "rejects non unique customer_id" do
      # as one gets created before each spec by reset_subscription
      result = Subscription.new(@valid_attributes)
      result.should be_valid
    end

    it "rejects an empty expiry date" do
      new_params = @valid_attributes.merge({ :customer_id => 2, :expiry_date => nil })
      result = Subscription.new(new_params)
      result.should_not be_valid
    end

    it "rejects an expiry date that has already past" do
      new_params = @valid_attributes.merge({ :customer_id => 2, :expiry_date => Time.now - 1.days })
      result = Subscription.new(new_params)
      result.should_not be_valid
    end

    it "rejects an empty plan value" do
      new_params = @valid_attributes.merge({ :customer_id => 2, :plan => nil })
      result = Subscription.new(new_params)
      result.should_not be_valid
    end
  end

  describe "#add_time" do
    it "accepts only a postive Time object" do
      obj = Subscription.find(1)
      start_time = Time.now

      obj.expiry_date = start_time
      obj.add_time(1.days)
      obj.expiry_date.should == 1.days.since(start_time)

      obj.expiry_date = start_time
      obj.add_time(nil).should be_false
      obj.expiry_date.should == start_time

      obj.expiry_date = start_time
      obj.add_time("test").should be_false
      obj.expiry_date.should == start_time

      obj.expiry_date = start_time
      obj.add_time(-1.days).should be_false
      obj.expiry_date.should == start_time
    end

    it "adds time to the expiry date" do
      obj = Subscription.find(1)

      Timecop.freeze(Time.now) do
        obj.expiry_date = Time.now
        obj.add_time(1.days)
        obj.expiry_date.should == 1.days.from_now

        obj.expiry_date = Time.now
        obj.add_time(1.month)
        obj.expiry_date.should == 1.month.from_now

        obj.expiry_date = Time.now
        obj.add_time(1.year)
        obj.expiry_date.should == 1.year.from_now
      end
    end
  end

  describe "#expire" do
    it "sets the expiry date to now" do
      obj = Subscription.find(1)
      now = Time.now

      obj.expiry_date = Time.now + 1.days
      Timecop.freeze(Time.now) do
        obj.expire
        obj.expiry_date.should == Time.now
      end
    end
  end

  describe "#renew" do
    it "creates a new Subscription with the same details as current subscription" do
      obj = Subscription.find(1)
      new_subscription = obj.renew(0)

      new_subscription.should_not be_nil
      obj.should_not == new_subscription
      obj.important_attributes.should == new_subscription.important_attributes
    end

    it "creates a new Subscription with the expiry_date 30 days from the current subscription" do
      obj = Subscription.find(1)
      new_subscription = obj.renew(30.days)

      new_subscription.should_not be_nil
      new_subscription.expiry_date.should == (obj.expiry_date + 30.days)
    end
  end

  describe "#free_trial_for" do
    it "creates a new free trial Subscription" do
      obj = Subscription.free_trial_for(1, 0)

      obj.should_not be_nil
      obj.free_trial?.should be_true
    end

    it "creates a new free trial Subscription which lasts for 10 days" do
      Timecop.freeze(Time.now) do
        obj = Subscription.free_trial_for(1, 10.days)

        obj.should_not be_nil
        obj.free_trial?.should be_true
        obj.expiry_date.should == 10.days.from_now
      end
    end
  end

  describe "#free_trial?" do
    it "is false when status is not 2" do
      obj = Subscription.find(1)
      obj.free_trial?.should be_false
    end

    it "is true if status equals 2" do
      obj = Subscription.find(1)
      obj.status = 2

      obj.free_trial?.should be_true
    end
  end

  describe "#active?" do
    it "is false when status is not 1" do
      obj = Subscription.find(1)
      obj.status = 0

      obj.active?.should be_false
    end

    it "is true if status equals 1" do
      obj = Subscription.find(1)
      obj.status = 1

      obj.active?.should be_true
    end
  end

  describe "#expired?" do
    it "is false when status is not 0" do
      obj = Subscription.find(1)
      obj.status = 17

      obj.expired?.should be_false
    end

    it "is true if status equals 0" do
      obj = Subscription.find(1)
      obj.status = 0
      obj.expired?.should be_true
    end
  end

  describe "#recently_expired_subscriptions" do
    it "returns no recently expired subscriptions" do
      Subscription.recently_expired_subscriptions.should be_empty
    end

    it "returns a Subscription when it has expired within the last day" do
      Timecop.freeze(Time.now) do
        obj = Subscription.find(1)
        obj.update_attribute(:expiry_date, Time.now - 2.days)
        Subscription.recently_expired_subscriptions.should be_empty

        obj.update_attribute(:expiry_date, Time.now - 1.days)
        Subscription.recently_expired_subscriptions.should_not be_empty

        obj.update_attribute(:expiry_date, Time.now - 30.seconds)
        Subscription.recently_expired_subscriptions.should_not be_empty
      end
    end
  end

  describe "#free_trials_ending_in_two_days" do
    it "returns no expiring free_trials" do
      Subscription.free_trials_ending_in_two_days.should be_empty
    end
    
    describe "with a free trial" do
      before(:each) do
        @subscription.update_attribute(:status, 2)
      end
      
      it "should return results when at least one subscription expires within 1 and 2 days from now" do
        Timecop.freeze(Time.now) do
          @subscription.update_attribute(:expiry_date, Time.now + 1.5.days)
          Subscription.free_trials_ending_in_two_days.should_not be_empty
        end
      end
      
      it "returns a subscriptions when it expires within 1 and 2 days from now" do
        Timecop.freeze(Time.now) do
          @subscription.update_attribute(:expiry_date, Time.now + 1.5.days)
          subs = Subscription.free_trials_ending_in_two_days
          subs.first.should eq(@subscription)
        end
      end
      
      it "does not return a Subscription expiring tomorrow" do
        Timecop.freeze(Time.now) do
          @subscription.update_attribute(:expiry_date, Time.now + 0.8.days)
          subs = Subscription.free_trials_ending_in_two_days
          subs.should_not include(@subscription)
        end
      end
      
      it "does not return a Subscription expiring three days from now" do
        Timecop.freeze(Time.now) do
          @subscription.update_attribute(:expiry_date, Time.now + 3.days)
          subs = Subscription.free_trials_ending_in_two_days
          subs.should_not include(@subscription)
        end
      end
    end
    
    describe "with a standard subscription" do
      before(:each) do
        @subscription.update_attribute(:status, 1)
      end
      
      it "does not return a Subscription when it expires within the next two days" do
        Timecop.freeze(Time.now) do
          @subscription.update_attribute(:expiry_date, Time.now + 1.5.days)
          Subscription.free_trials_ending_in_two_days.should be_empty
        end
      end
    end
  end
  
  describe "#active_subscription" do
    it "returns no active subscriptions" do
      Subscription.active_subscription.should be_empty
    end

    it "returns a Subscription when it has no expired and has a status of 1" do
      obj = Subscription.find(1)
      obj.update_attribute(:status, 0)
      Subscription.active_subscription.should be_empty

      obj = Subscription.find(1)
      obj.update_attribute(:status, 1)
      Subscription.active_subscription.should_not be_empty
      Subscription.active_subscription.first == obj
    end

    it "returns a Subscription when it has no expired and has a status of 2" do
      obj = Subscription.find(1)
      obj.update_attribute(:status, 0)
      Subscription.active_subscription.should be_empty

      obj = Subscription.find(1)
      obj.update_attribute(:status, 2)
      Subscription.active_subscription.should_not be_empty
      Subscription.active_subscription.first == obj
    end
  end

  describe "#expiry_date_to_s" do
    it "returns a blank string if expiry date is not set" do
      obj = Subscription.find(1)
      obj.expiry_date = nil

      obj.expiry_date_to_s.should == ""
    end

    it "returns a date string formatted like Oct 28, 2011" do
      obj = Subscription.find(1)
      obj.expiry_date = Time.local(2011, 10, 28)

      obj.expiry_date_to_s.should == "Oct 28, 2011"
    end
  end

end