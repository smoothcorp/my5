require 'spec_helper'

describe Payment do

  def reset_payment(options = {})
    @valid_attributes = {
      :id => 1,
      :subscription_id => 1,
      :amount => 50.0,
      :status => 0
    }

    @payment.destroy! if @payment
    @payment = Payment.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_payment
  end

  context "validations" do

    it "rejects an empty amount" do
      new_params = @valid_attributes.merge({ :amount => nil })
      result = Payment.new(new_params)
      result.should_not be_valid
    end

  end

  context "#amount_in_cents" do
    it "multiplies amount by 100" do
      p = Payment.new
      p.amount = 1
      p.amount_in_cents.should == 100

      p.amount = 25
      p.amount_in_cents.should == 2500

      p.amount = 73.98
      p.amount_in_cents.should == 7398
    end

    it "returns 0 when the amount is nil or 0" do
      p = Payment.new
      p.amount = nil
      p.amount_in_cents.should == 0

      p = Payment.new
      p.amount = 0
      p.amount_in_cents.should == 0
    end
  end

  context "#paid?" do
    it "is false when status is not 1" do
      obj = Payment.find(1)
      obj.paid?.should be_false
    end

    it "is true when status is 1" do
      obj = Payment.find(1)
      obj.status = 1

      obj.paid?.should be_true
    end
  end

  context "can_process?" do
    it "is false unless eway_token and amount are present, and status is 0" do
      obj = Payment.new(:status => -1)
      obj.can_process?.should be_false

      obj.eway_token = "ABCD1234"
      obj.can_process?.should be_false

      obj.amount = 10.0
      obj.can_process?.should be_false
    end

    it "is true when eway_token and amount are present, and status is 0" do
      obj = Payment.new(:status => 0, :eway_token => "9876543211000", :amount => 10.0)
      obj.can_process?.should be_true
    end
  end

  context "#process" do
    it "changes the status to paid (1) with valid details" do
      obj = Payment.new(:status => 0, :eway_token => "9876543211000", :amount => 10.0)
      obj.can_process?.should be_true
      obj.process

      obj.status.should == 1
      obj.invoice_no.should == "MY51"
    end
  end
end
