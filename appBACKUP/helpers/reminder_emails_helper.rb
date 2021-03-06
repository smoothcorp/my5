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
    reminder.time.strftime("%l:%M%P")
  end
end
