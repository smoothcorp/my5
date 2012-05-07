class ReminderEmail < ActiveRecord::Base
  belongs_to :customer

  validates :time, :days_of_week, :customer_id, :presence => true
  attr_accessor :days_of_week_input
  
  before_save :set_time_for_daylight_savings
  DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

  def self.active_in_last_5mins
    temp = Time.now.wday - 1
    temp = 6 if temp < 0

    todays_reminders = ReminderEmail.where(:days_of_week.matches => "%#{temp}%")

    five_mins_ago = 5.minutes.ago.utc.time_of_day!
    now = Time.now.utc.time_of_day!
    time_range = (five_mins_ago..now)

    todays_reminders.keep_if {|reminder| time_range.cover?(reminder.time.utc.time_of_day!)}
  end

  def days_of_week_in_words
    return [] if self.days_of_week.blank?
    self.days_of_week.split(',').collect { |index| DAYS[Integer(index)] }
  end

  def days_of_week_count
    self.days_of_week.split(',').count
  end

  def available_inputs
    DAYS.collect.with_index { |label, index| [label, index.to_s] }
  end

  def remind
    ReminderEmailMailer.reminder(self.customer).deliver
  end

  private

  def set_time_for_daylight_savings
    self.time = self.time - 1.hour
  end
end
