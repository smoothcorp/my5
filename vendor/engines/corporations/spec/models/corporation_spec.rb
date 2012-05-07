require 'spec_helper'

describe Corporation do
  ### -------------
  ### ---- AVERAGE LOGIN TIME SINCE
  ### -------------
  describe "#average_login_time_since" do
    before(:each) do
      Timecop.freeze(Time.now)
      Corporation.delete_all
      Customer.delete_all
      @corporation = Factory.create(:corporation)
    end
    
    describe "with customers" do
      before(:each) do
        @customer = Factory.create(:customer)
        @customer.update_attribute(:corporation_id, @corporation.id)
      end
      
      describe "with occurences" do
        before(:each) do
          Event.delete_all
          @event = Factory.create(:event)
          Occurence.delete_all
          occurences = (1..5).inject([]) do |a, i|
            a << Factory.create(:occurence, :event => @event, :customer => @customer)
          end
        end
        
        it "returns time in text format" do
          @customer.login_time_since_raw_seconds(Time.now - (Occurence.count + 2).hours).to_i.should eq(14400)
          @corporation.average_login_time_since(Time.now - (Occurence.count + 2).hours).should eq("04:00:00")
        end
    
        it "returns time only within the timeframe" do
          Customer.any_instance.stub(:login_time_since_raw_seconds).and_return(7200)
          @corporation.average_login_time_since(@customer.occurences.last.created_at + 1.hour).should eq("02:00:00")
        end
      
        it "returns time in text format with multiple customers" do
          @customer2 = Factory.create(:customer)
          @customer2.update_attribute(:corporation_id, @corporation.id)
          
          expect {
            occurences = (1..3).inject([]) do |a, i|
              a << Factory.create(:occurence, :event => @event, :customer => @customer2)
            end
          }.to change(@customer2.occurences, :count).by(3)
          
          Customer.any_instance.stub(:login_time_since_raw_seconds).and_return(10800)
          @corporation.average_login_time_since(Occurence.last.created_at + 12.hours).should eq("03:00:00")
        end
        
        it "returns correct average if customer exists with nil occurences" do
          
        end
      end
      
      describe "without occurences" do
        it "returns 00" do
          Occurence.delete_all
          @corporation.average_login_time_since(Date.today - 6.days).should eq("00:00:00")
        end
      end
    end
      
    describe "without customers" do
      it "returns 00" do
        @corporation.customers.delete_all
        @corporation.average_login_time_since(Date.today - 6.days).should eq("00:00:00")
      end
    end
  end
  
  ### -------------
  ### ---- AVERAGE LOGIN TIME ON
  ### -------------
  describe "#average_login_time_on" do
    before(:each) do
      Timecop.freeze(Time.now)
      Corporation.delete_all
      Customer.delete_all
      @corporation = Factory.create(:corporation)
    end
    
    describe "with customers" do
      before(:each) do
        @customer = Factory.create(:customer)
        @customer.update_attribute(:corporation_id, @corporation.id)
      end
      
      describe "with occurences" do
        before(:each) do
          Event.delete_all
          @event = Factory.create(:event)
          Occurence.delete_all
          occurences = (1..5).inject([]) do |a, i|
            a << Factory.create(:occurence_half_days_apart, :event => @event, :customer => @customer)
          end
        end
        
        it "returns time in text format" do
          @customer.login_time_on_raw_seconds(@customer.occurences.last.created_at + 24.hours).to_i.should eq(43200)
          @corporation.average_login_time_on(@customer.occurences.last.created_at + 24.hours).should eq("12:00:00")
        end
      
        it "returns time in text format with multiple customers" do
          @customer2 = Factory.create(:customer)
          @customer2.update_attribute(:corporation_id, @corporation.id)
          
          expect {
            occurences = (1..3).inject([]) do |a, i|
              a << Factory.create(:occurence, :event => @event, :customer => @customer2)
            end
          }.to change(@customer2.occurences, :count).by(3)
          
          # Stubbing works nicely
          Customer.any_instance.stub(:login_time_on_raw_seconds).and_return(43200)
          @corporation.average_login_time_on(Date.yesterday).should eq("12:00:00")
        end
      end
      
      describe "without occurences" do
        it "returns 00" do
          Occurence.delete_all
          @corporation.average_login_time_on(Date.today).should eq("00:00:00")
        end
      end
    end
      
    describe "without customers" do
      before(:each) do
        Customer.delete_all
      end
      
      it "returns 00" do
        @corporation.average_login_time_on(Date.today).should eq("00:00:00")
      end
    end
  end
  
  ### -------------
  ### ---- AVERAGE TIME PER EVENT
  ### -------------
  describe "#average_time_per_event" do
    before(:all) do
      Corporation.delete_all
      Customer.delete_all
      @static_corporation = Factory.create(:corporation)
      @customer = Factory.create(:customer)
      @customer.update_attribute(:corporation_id, @static_corporation.id)
    end
    
    describe "with event" do
      before(:all) do
        Event.delete_all
        @event = Factory.create(:event)
      end
      
      describe "with occurences" do
        before(:all) do
          Occurence.delete_all
          occurences = (1..5).inject([]) do |a, i|
            a << Factory.create(:occurence, :event => @event, :customer => @customer)
          end
        end
        
        it "returns time in text format by default" do
          @static_corporation.average_time_per_event(@event.title, Occurence.last.created_at - 12.hours).should eq("04:00:00")
        end

        it "returns time in decimal form if specified" do
          @static_corporation.average_time_per_event(@event.title, Occurence.last.created_at - 12.hours, nil, "time_as_hours").should eq("4.00")
        end
        
        it "returns time only within the timeframe" do
          @static_corporation.average_time_per_event(@event.title, @event.occurences.last.created_at + 2.5.hours).should eq("01:00:00")
        end

        it "doubles with second session" do
          expect {
            occurences = (1..3).inject([]) do |a, i|
              a << Factory.create(:occurence_alt_session, :event => @event, :customer => @customer)
            end
          }.to change(@customer.occurences, :count).by(3)

          @static_corporation.average_time_per_event(@event.title, Occurence.find(:first, :order => "created_at ASC").created_at - 12.hours).should eq("03:00:00")
        end
      end
      
      describe "without occurences" do
        before(:all) do
          # Clear it all out
          Corporation.delete_all
          Customer.delete_all
          Event.delete_all
          Occurence.delete_all
          @static_corporation = Factory.create(:corporation)
          @customer = Factory.create(:customer)
          @customer.update_attribute(:corporation_id, @static_corporation)
          @customer.save!
          @event = Factory.create(:event)
        end
        
        it "returns 0 if there are no occurences for this user" do
          @static_corporation.average_time_per_event(@event.title, Time.now - (Occurence.count + 12).hours).should eq("00:00:00")
        end
      end
    end
    
    describe "without event" do
      before(:each) do
        Event.delete_all
      end
      
      it "returns 0" do
        @static_corporation.average_time_per_event("Event Title", Time.now - (Occurence.count + 12).hours).should eq(0)
      end
    end
  end
  
end