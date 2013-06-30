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

    variable = {"London"=>[0, 0], "Kyiv"=>[3, 0], "Sydney"=>[11, 0]}
    
    if variable[current_customer.time_zone]
      hour_off_set = variable[current_customer.time_zone][0]
      mins_off_set = variable[current_customer.time_zone][1]
    else
      Time.zone = current_customer.time_zone
      z = Time.zone.now.to_s
      hour_off_set = z[-5] + z[-4] + z[-3]
      mins_off_set = z[-2] + z[-1]
    end
    
    rem = reminder.time.utc + hour_off_set.to_i.hour + mins_off_set.to_i.minutes
    rem.strftime("%l:%M%P")
  end
end
