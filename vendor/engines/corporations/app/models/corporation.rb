require 'time_helpers'

class Corporation < ActiveRecord::Base
  acts_as_indexed :fields => [:name]
  validates :name, :presence => true, :uniqueness => true

  belongs_to :logo, :class_name => 'Image'
  has_many :customers
  has_many :departments

  def self.available_for_form
    Corporation.all.collect { |c| [c.name, c.id] }
  end
  
  def active?
    self.active
  end
  
  def average_login_time_since(start_date)
    if self.customers.blank?
      return "00:00:00"
    else
      seconds = (self.customers.inject(0) {|sum,k| sum += k.login_time_since_raw_seconds(start_date)}) / (self.customers.with_occurences.count.to_i == 0 ? 1 : self.customers.with_occurences.count) 
      TimeHelpers.time_in_digital_text_format seconds
    end
  end
  
  def average_login_time_on(date)
    if self.customers.blank?
      return "00:00:00"
    else
      seconds = (self.customers.inject(0) {|sum,k| sum += k.login_time_on_raw_seconds(date)}) / (self.customers.with_occurences.count.to_i == 0 ? 1 : self.customers.with_occurences.count) 
      TimeHelpers.time_in_digital_text_format seconds
    end
  end
  
  def average_time_per_event(event_title, start_date, end_date=nil, time_format=nil)
    event = Event.find_by_title(event_title)
    end_date = end_date.blank? ? Time.now : end_date
    if event
      users = self.customers.collect(&:id)
      total_time = 0
      occurences = event.occurences.where(:created_at.gte => start_date, :created_at.lte => end_date, :user_id => users).select("user_id, session_id, MIN(created_at) as min, MAX(created_at) as max").group("session_id")
      #occurences.each {|occurence| total_time += Time.diff(Time.parse(occurence.min), Time.parse(occurence.max), '%S')[:diff].to_i} unless occurences.blank?
      occurences.each {|occurence| total_time += Time.diff(occurence.min, occurence.max, '%S')[:diff].to_i} unless occurences.blank?
      total_time = total_time / occurences.size unless occurences.blank?
      if time_format == "time_as_hours"
        TimeHelpers.time_in_decimal_hours_format(total_time)
      else
        TimeHelpers.time_in_digital_text_format(total_time)
      end
    else
      0
    end
  end
end
