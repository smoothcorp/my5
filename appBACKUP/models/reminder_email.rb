class ReminderEmail < ActiveRecord::Base
  belongs_to :customer

  validates :time, :days_of_week, :customer_id, :presence => true
  attr_accessor :days_of_week_input
  
  DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

  def self.active_in_last_5mins
    temp = Time.now.wday - 1
    temp = 6 if temp < 0
    h1 = Time.now.utc.strftime("%H")
    m1 = Time.now.utc.strftime("%M")
    todays_reminders = ReminderEmail.where(:days_of_week.matches => "%#{temp}%").where("(Hour(time) = ? ) AND (Minute(time) = ?)",h1,m1)
    todays_reminders
  end

  def days_of_week_in_words
    return [] if self.days_of_week.blank?
    self.days_of_week.split(',').collect { |index| DAYS[Integer(index)] }
  end

  def days_of_week_count
    self.days_of_week.split(',').count
  end

  def available_inputs
#     DAYS.collect.with_index { |label, index| [label, index.to_s] }
    DAYS.enum_with_index.collect {|label, index| [label, index.to_s]}

  end

  def remind
    ReminderEmailMailer.reminder(self.customer).deliver
  end

end
