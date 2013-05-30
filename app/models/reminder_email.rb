class ReminderEmail < ActiveRecord::Base
  # before_save :set_time_for_daylight_savings

  belongs_to :customer

  validates :time, :days_of_week, :customer_id, :presence => true
  attr_accessor :days_of_week_input

  DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

  def is_in_last_5mins
    Time.zone = self.customer.time_zone

    temp = Time.zone.now.wday - 1
    temp = 6 if temp < 0

    curH      = Time.zone.now.strftime("%H")
    curM      = Time.zone.now.strftime("%M")

    curH  = curH.to_i
    curM  = curM.to_i
    curM2 = curM - 5

    remH = self.time.utc.strftime("%H")
    remM = self.time.utc.strftime("%M")
    remH = remH.to_i
    remM = remM.to_i

    #remH = (remH - 13 + 24) % 24
    offset = Time.zone.formatted_offset.to_i
    remH = (remH + offset) % 24

    if remH == curH && remM <= curM && remM > curM2
      #if self.customer_id == 254
# =======
#     # offset = Time.zone.formatted_offset.to_i


#     z = Time.zone.now.to_s
#     hou = z[-5] + z[-4] + z[-3]
#     min = z[-2] + z[-1]

#     remM = remM.to_i + min.to_i
#     remH = (remH + hou.to_i) % 24

#     if remM == 60
#       remH += 1
#       remM = 0
#     end

# puts '===='*20
# puts 'reminder Hour'
# puts remH
# puts 'current Hour'
# puts curH
# puts '===='*20
# puts remM
# puts curM
# puts '===='*20
# puts remM
# puts curM2
# puts '===='*20

#     if remH == curH && remM <= curM && remM > curM2

#       puts '%'*200

# >>>>>>> Stashed changes
      return self
    end
    nil
  end

  def self.active_in_last_5mins
    nil
  end

  def self.active_in_days_of_week
    temp = Time.now.wday - 1
    temp = 6 if temp < 0
    todays_reminders = ReminderEmail.where(:days_of_week.matches => "%#{temp}%")
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
    #DAYS.collect.with_index { |label, index| [label, index.to_s] }
    DAYS.enum_with_index.collect {|label, index| [label, index.to_s]}
  end

  def remind
    ReminderEmailMailer.reminder(self.customer).deliver
  end


  private
  def set_time_for_daylight_savings
    # Unused method
    self.time = self.time - 1.hour
  end
end
