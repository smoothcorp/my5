class ReminderEmail < ActiveRecord::Base
  # before_save :set_time_for_daylight_savings

  belongs_to :customer

  validates :time, :days_of_week, :customer_id, :presence => true
  attr_accessor :days_of_week_input

  DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

  def is_in_last_5mins
    # ZONE = {"London"=>[0, 0], "Kiyv"=>[3, 30], "Sydney"=>[11, 0]}
    
    # hour_off_set = ZONE[self.customer.time_zone][0]
    # mins_off_set = ZONE[self.customer.time_zone][1]

    # now = Time.now.utc + hour_off_set.hour + mins_off_set.minutes
    # curH = now.hour
    # curM = now.min
    # curM2 = curM - 5

    # rem = self.time.utc + hour_off_set.hour + mins_off_set.minutes
    # remH = rem.strftime("%H").to_i # 23 - часа
    # remM = rem.strftime("%M").to_i # 49 - минут



    now = Time.now.utc
    curH = now.strftime("%H").to_i
    curM = now.strftime("%M").to_i
    curM2 = curM - 5

    # так как в БД хранится инфа по UTC - то преобразовывать не надо
    rem = self.time.utc
    remH = rem.strftime("%H").to_i     # 08 - ремаиндер в БД - часы 
    remM = rem.strftime("%M").to_i     # 30 - ремаиндер в БД - минуты



    # # Ремаиндер на 11:30 по киеву 
    # # В БД лежит под 8:30

    # Time.zone = self.customer.time_zone              # Kiyv

    # curH = Time.zone.now.strftime("%H")              # 11 - утро ( 11 часов утра )
    # curM = Time.zone.now.strftime("%M")              # 34 - 11:34 время
 
    # curH  = curH.to_i                                # 11 - число ( 11 утра )
    # curM  = curM.to_i                                # 34 - число 11:34 время
    # curM2 = curM - 5                                 # 29 - минус ( 5 минут от 34 )
 
    # remH = self.time.utc.strftime("%H")              # 08 - ремаиндер в БД - часы 
    # remM = self.time.utc.strftime("%M")              # 30 - ремаиндер в БД - минуты

    # z = Time.zone.now.to_s                      # 2013-06-28 11:42:06 +0300   - время на данный момент
    # hou = z[-5] + z[-4] + z[-3]                 # "+03" - часы
    # min = z[-2] + z[-1]                         # "00" - минуты

    # remM = remM.to_i + min.to_i                 # 30 минут + 00 минут
    # remH = (remH.to_i + hou.to_i) % 24          # (08 часов + "+03") % 24 => 11 часов

    # if remM >= 60
    #   remH += 1
    #   remM = remM - 60
    # end

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

    # Time.zone = self.customer.time_zone

    # curH      = Time.zone.now.strftime("%H")
    # curM      = Time.zone.now.strftime("%M")

    # curH  = curH.to_i
    # curM  = curM.to_i
    # curM2 = curM - 5

    # remH = self.time.utc.strftime("%H")
    # remM = self.time.utc.strftime("%M")
    # remH = remH.to_i
    # remM = remM.to_i

    # offset = Time.zone.formatted_offset.to_i
    # remH = (remH + offset) % 24

    if remH == curH && remM <= curM && remM > curM2
      return self
    end
    nil
  end

  def self.active_in_last_5mins
    nil
  end

  def self.active_in_days_of_week
    variable = own_time_zones
    
    if variable[current_customer.time_zone]
      hour_off_set = variable[current_customer.time_zone][0]
      mins_off_set = variable[current_customer.time_zone][1]
      offset = hour_off_set.hour + mins_off_set.minutes

      temp = (Time.now.utc + offset).wday - 1
    else
      temp = Time.now.utc.wday - 1
    end

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

  def own_time_zones
    { "International Date Line West" => [-12, 0], "Midway Island" => [-11, 0], "American Samoa" => [-11, 0], "Hawaii" => [-10, 0], "Alaska" => [-8, 0], "Pacific Time (US & Canada)" => [-8, 0], "Tijuana" => [-7, 0], "Mountain Time (US & Canada)" => [-7, 0], "Arizona" => [-7, 0], "Chihuahua" => [-6, 0], "Mazatlan" => [-6, 0], "Central Time (US & Canada)" => [-5, 0], "Saskatchewan" => [-6, 0], "Guadalajara" => [-5, 0], "Mexico City" => [-5, 0], "Monterrey" => [-5, 0], "Central America" => [-5, 0], "Eastern Time (US & Canada)" => [-5, 0], "Indiana (East)" => [-4, 0], "Bogota" => [-5, 0], "Lima" => [-5, 0], "Quito" => [-5, 0], "Atlantic Time (Canada)" => [-4, 0], "Caracas" => [-4, -30], "La Paz" => [-4, 0], "Santiago" => [-4, 0], "Newfoundland" => [-2, -30], "Brasilia" => [-3, 0], "Buenos Aires" => [-3, 0], "Montevideo" => [-3, 0], "Georgetown" => [-3, 0], "Greenland" => [-3, 0], "Mid-Atlantic" => [-2, 0], "Azores" => [-1, 0], "Cape Verde Is." => [-1, 0], "Dublin" => [0, 0], "Edinburgh" => [1, 0], "Lisbon" => [1, 0], "London" => [1, 0], "Casablanca" => [1, 0], "Monrovia" => [0, 0], "UTC" => [0, 0], "Belgrade" => [2, 0], "Bratislava" => [2, 0], "Budapest" => [2, 0], "Ljubljana" => [2, 0], "Prague" => [2, 0], "Sarajevo" => [2, 0], "Skopje" => [2, 0], "Warsaw" => [2, 0], "Zagreb" => [2, 0], "Brussels" => [2, 0], "Copenhagen" => [2, 0], "Madrid" => [2, 0], "Paris" => [2, 0], "Amsterdam" => [2, 0], "Berlin" => [2, 0], "Bern" => [2, 0], "Rome" => [2, 0], "Stockholm" => [2, 0], "Vienna" => [2, 0], "West Central Africa" => [2, 0], "Bucharest" => [3, 0], "Cairo" => [2, 0], "Helsinki" => [3, 0], "Kyiv" => [3, 0], "Riga" => [3, 0], "Sofia" => [3, 0], "Tallinn" => [3, 0], "Vilnius" => [3, 0], "Athens" => [3, 0], "Istanbul" => [3, 0], "Minsk" => [3, 0], "Jerusalem" => [3, 0], "Harare" => [2, 0], "Pretoria" => [2, 0], "Moscow" => [4, 0], "St. Petersburg" => [4, 0], "Volgograd" => [4, 0], "Kuwait" => [3, 0], "Riyadh" => [3, 0], "Nairobi" => [3, 0], "Baghdad" => [3, 0], "Tehran" => [4, 30], "Abu Dhabi" => [4, 0], "Muscat" => [4, 0], "Baku" => [5, 0], "Tbilisi" => [4, 0], "Yerevan" => [4, 0], "Kabul" => [4, 30], "Ekaterinburg" => [6, 0], "Islamabad" => [5, 0], "Karachi" => [5, 0], "Tashkent" => [5, 0], "Chennai" => [5, 30], "Kolkata" => [5, 30], "Mumbai" => [5, 30], "New Delhi" => [5, 30], "Kathmandu" => [5, 45], "Astana" => [6, 0], "Dhaka" => [6, 0], "Sri Jayawardenepura" => [5, 30], "Almaty" => [6, 0], "Novosibirsk" => [7, 0], "Rangoon" => [6, 30], "Bangkok" => [7, 0], "Hanoi" => [7, 0], "Jakarta" => [7, 0], "Krasnoyarsk" => [8, 0], "Beijing" => [8, 0], "Chongqing" => [8, 0], "Hong Kong" => [8, 0], "Urumqi" => [8, 0], "Kuala Lumpur" => [8, 0], "Singapore" => [8, 0], "Taipei" => [8, 0], "Perth" => [8, 0], "Irkutsk" => [9, 0], "Ulaanbaatar" => [8, 0], "Seoul" => [9, 0], "Osaka" => [9, 0], "Sapporo" => [9, 0], "Tokyo" => [9, 0], "Yakutsk" => [10, 0], "Darwin" => [9, 30], "Adelaide" => [9, 30], "Canberra" => [10, 0], "Melbourne" => [10, 0], "Sydney" => [10, 0], "Brisbane" => [10, 0], "Hobart" => [10, 0], "Vladivostok" => [11, 0], "Guam" => [10, 0], "Port Moresby" => [10, 0], "Magadan" => [12, 0], "Solomon Is." => [11, 0], "New Caledonia" => [11, 0], "Fiji" => [12, 0], "Kamchatka" => [12, 0], "Marshall Is." => [12, 0], "Auckland" => [12, 0], "Wellington" => [12, 0], "Nuku'alofa" => [13, 0], "Tokelau Is." => [13, 0], "Chatham Is." => [12, 45], "Samoa" => [13, 0] }
  end

  private
  def set_time_for_daylight_savings
    # Unused method
    self.time = self.time - 1.hour
  end
end
