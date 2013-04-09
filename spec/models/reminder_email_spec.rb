require 'spec_helper'

describe ReminderEmail do

  context "#days_of_week_in_words" do
    it "is empty when days_of_week is unpopulated" do
      obj = ReminderEmail.new
      obj.days_of_week = ""

      obj.days_of_week_in_words.should be_empty
    end

    it "is an array of all days of the week wehn days_of_week has numbers 0 through 6" do
      obj = ReminderEmail.new
      obj.days_of_week = "0,1,2,3,4,5,6"

      obj.days_of_week_in_words.should == ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    end

    it "is an array with only the days indicated by days_of_week" do
      obj = ReminderEmail.new
      obj.days_of_week = "0,2,4,6"

      obj.days_of_week_in_words.should == ['Monday', 'Wednesday', 'Friday', 'Sunday']
    end
  end

  context "#days_of_week_count" do
    it "is zero when days_of_week is unpopulated" do
      obj = ReminderEmail.new
      obj.days_of_week = ""

      obj.days_of_week_count.should == 0
    end

    it "is 7 when days_of_week has numbers 0 through 6" do
      obj = ReminderEmail.new
      obj.days_of_week = "0,1,2,3,4,5,6"

      obj.days_of_week_count.should == 7
    end

    it "is 4 with only the days indicated by days_of_week" do
      obj = ReminderEmail.new
      obj.days_of_week = "0,2,4,6"

      obj.days_of_week_count.should == 4
    end
  end
  
  context ".active_in_last_5mins" do
    before(:each) { ReminderEmail.create!(time: 2.days.ago, days_of_week: "0,1,2,3,4,5,6", customer_id: 1) }
    subject { ReminderEmail.active_in_last_5mins }

    it "should ignore the date and just give us the time" do
      subject.should be_nil
    end
  end
end
