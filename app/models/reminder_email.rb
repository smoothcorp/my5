class ReminderEmail < ActiveRecord::Base
  # before_save :set_time_for_daylight_savings

  belongs_to :customer

  validates :time, :days_of_week, :customer_id, :presence => true
  attr_accessor :days_of_week_input

  DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

  def is_in_last_5mins
    danielle = Customer.first
    if danielle == self.customer
      Rails.logger.info '===='*200
      puts Time.zone.now
      puts Time.zone.now.wday - 1
      puts Time.zone.now.strftime("%H")
      puts Time.zone.now.strftime("%M")
      puts 'Time of reminder'
      puts self.time.utc.strftime("%H")
      puts self.time.utc.strftime("%M")

      Rails.logger.info '===='*200
    end

    # Ремаиндер на 11:30 по киеву 
    # В БД лежит под 8:30

    Time.zone = self.customer.time_zone              # Kiyv

    temp = Time.zone.now.wday - 1                    # 4 - пятница - 1 день
    temp = 6 if temp < 0                             # nil

    curH = Time.zone.now.strftime("%H")              # 11 - утро ( 11 часов утра )
    curM = Time.zone.now.strftime("%M")              # 34 - 11:34 время
 
    curH  = curH.to_i                                # 11 - число ( 11 утра )
    curM  = curM.to_i                                # 34 - число 11:34 время
    curM2 = curM - 5                                 # 29 - минус ( 5 минут от 34 )
 
    remH = self.time.utc.strftime("%H")              # 08 - ремаиндер в БД - часы 
    remM = self.time.utc.strftime("%M")              # 30 - ремаиндер в БД - минуты

    z = Time.zone.now.to_s                      # 2013-06-28 11:42:06 +0300   - время на данный момент
    hou = z[-5] + z[-4] + z[-3]                 # "+03" - часы
    min = z[-2] + z[-1]                         # "00" - минуты

    remM = remM.to_i + min.to_i                 # 30 минут + 00 минут
    remH = (remH.to_i + hou.to_i) % 24          # (08 часов + "+03") % 24 => 11 часов

    if remM >= 60
      remH += 1
      remM = remM - 60
    end

# Rails.logger.info 'reminder Hour'
# Rails.logger.info remH
# Rails.logger.info 'current Hour'
# Rails.logger.info curH
# Rails.logger.info '===='*20
# Rails.logger.info 'current Minutes top'
# Rails.logger.info curM
# Rails.logger.info 'reminder Minutes'
# Rails.logger.info remM
# Rails.logger.info 'current Minutes bottom'
# Rails.logger.info curM2
# Rails.logger.info '===='*20

    if remH == curH && remM <= curM && remM > curM2
      # puts '>'*200
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
