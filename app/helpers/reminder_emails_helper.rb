module ReminderEmailsHelper
  def reminder_link_in_words(reminder)
    link_to "#{time_for_reminder(reminder)} #{frequency_for_reminder(reminder)}", edit_my5_reminder_email_path(reminder)
  end

  def frequency_for_reminder(reminder)
    days_in_words = if (days_count = reminder.days_of_week_count) && days_count == 1
      reminder.days_of_week_in_words.last
    elsif days_count == 7
      'day'
    elsif days_count > 1
      temp = reminder.days_of_week_in_words[0...(days_count-1)].join(', ')
      "#{temp} and #{reminder.days_of_week_in_words.last}"
    else
      "Invalid"
    end

    "Every #{days_in_words}"
  end

  def time_for_reminder(reminder)
    return "" if reminder.nil? or reminder.time.nil?

    #variable = { "International Date Line West" => [-12, 0], "Midway Island" => [-11, 0], "American Samoa" => [-11, 0], "Hawaii" => [-10, 0], "Alaska" => [-8, 0], "Pacific Time (US & Canada)" => [-8, 0], "Tijuana" => [-7, 0], "Mountain Time (US & Canada)" => [-7, 0], "Arizona" => [-7, 0], "Chihuahua" => [-6, 0], "Mazatlan" => [-6, 0], "Central Time (US & Canada)" => [-5, 0], "Saskatchewan" => [-6, 0], "Guadalajara" => [-5, 0], "Mexico City" => [-5, 0], "Monterrey" => [-5, 0], "Central America" => [-5, 0], "Eastern Time (US & Canada)" => [-4, 0], "Indiana (East)" => [-4, 0], "Bogota" => [-5, 0], "Lima" => [-5, 0], "Quito" => [-5, 0], "Atlantic Time (Canada)" => [-4, 0], "Caracas" => [-4, -30], "La Paz" => [-4, 0], "Santiago" => [-4, 0], "Newfoundland" => [-2, -30], "Brasilia" => [-3, 0], "Buenos Aires" => [-3, 0], "Montevideo" => [-3, 0], "Georgetown" => [-3, 0], "Greenland" => [-3, 0], "Mid-Atlantic" => [-2, 0], "Azores" => [-1, 0], "Cape Verde Is." => [-1, 0], "Dublin" => [0, 0], "Edinburgh" => [1, 0], "Lisbon" => [1, 0], "London" => [1, 0], "Casablanca" => [1, 0], "Monrovia" => [0, 0], "UTC" => [0, 0], "Belgrade" => [2, 0], "Bratislava" => [2, 0], "Budapest" => [2, 0], "Ljubljana" => [2, 0], "Prague" => [2, 0], "Sarajevo" => [2, 0], "Skopje" => [2, 0], "Warsaw" => [2, 0], "Zagreb" => [2, 0], "Brussels" => [2, 0], "Copenhagen" => [2, 0], "Madrid" => [2, 0], "Paris" => [2, 0], "Amsterdam" => [2, 0], "Berlin" => [2, 0], "Bern" => [2, 0], "Rome" => [2, 0], "Stockholm" => [2, 0], "Vienna" => [2, 0], "West Central Africa" => [2, 0], "Bucharest" => [3, 0], "Cairo" => [2, 0], "Helsinki" => [3, 0], "Kyiv" => [3, 0], "Riga" => [3, 0], "Sofia" => [3, 0], "Tallinn" => [3, 0], "Vilnius" => [3, 0], "Athens" => [3, 0], "Istanbul" => [3, 0], "Minsk" => [3, 0], "Jerusalem" => [3, 0], "Harare" => [2, 0], "Pretoria" => [2, 0], "Moscow" => [4, 0], "St. Petersburg" => [4, 0], "Volgograd" => [4, 0], "Kuwait" => [3, 0], "Riyadh" => [3, 0], "Nairobi" => [3, 0], "Baghdad" => [3, 0], "Tehran" => [4, 30], "Abu Dhabi" => [4, 0], "Muscat" => [4, 0], "Baku" => [5, 0], "Tbilisi" => [4, 0], "Yerevan" => [4, 0], "Kabul" => [4, 30], "Ekaterinburg" => [6, 0], "Islamabad" => [5, 0], "Karachi" => [5, 0], "Tashkent" => [5, 0], "Chennai" => [5, 30], "Kolkata" => [5, 30], "Mumbai" => [5, 30], "New Delhi" => [5, 30], "Kathmandu" => [5, 45], "Astana" => [6, 0], "Dhaka" => [6, 0], "Sri Jayawardenepura" => [5, 30], "Almaty" => [6, 0], "Novosibirsk" => [7, 0], "Rangoon" => [6, 30], "Bangkok" => [7, 0], "Hanoi" => [7, 0], "Jakarta" => [7, 0], "Krasnoyarsk" => [8, 0], "Beijing" => [8, 0], "Chongqing" => [8, 0], "Hong Kong" => [8, 0], "Urumqi" => [8, 0], "Kuala Lumpur" => [8, 0], "Singapore" => [8, 0], "Taipei" => [8, 0], "Perth" => [8, 0], "Irkutsk" => [9, 0], "Ulaanbaatar" => [8, 0], "Seoul" => [9, 0], "Osaka" => [9, 0], "Sapporo" => [9, 0], "Tokyo" => [9, 0], "Yakutsk" => [10, 0], "Darwin" => [9, 30], "Adelaide" => [9, 30], "Canberra" => [10, 0], "Melbourne" => [10, 0], "Sydney" => [10, 0], "Brisbane" => [10, 0], "Hobart" => [10, 0], "Vladivostok" => [11, 0], "Guam" => [10, 0], "Port Moresby" => [10, 0], "Magadan" => [12, 0], "Solomon Is." => [11, 0], "New Caledonia" => [11, 0], "Fiji" => [12, 0], "Kamchatka" => [12, 0], "Marshall Is." => [12, 0], "Auckland" => [12, 0], "Wellington" => [12, 0], "Nuku'alofa" => [13, 0], "Tokelau Is." => [13, 0], "Chatham Is." => [12, 45], "Samoa" => [13, 0] }
    #
    #if variable[current_customer.time_zone]
    #  hour_off_set = variable[current_customer.time_zone][0]
    #  mins_off_set = variable[current_customer.time_zone][1]
    #else
    #  Time.zone = current_customer.time_zone
    #  z = Time.zone.now.to_s
    #  hour_off_set = z[-5] + z[-4] + z[-3]
    #  mins_off_set = z[-2] + z[-1]
    #end
    
    #rem = reminder.time.utc + hour_off_set.to_i.hour + mins_off_set.to_i.minutes
    rem  = Time.zone.parse(reminder.string_time)
    rem.strftime("%l:%M%P")
  end
end
