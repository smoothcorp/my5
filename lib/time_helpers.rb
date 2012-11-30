class TimeHelpers
  def self.time_in_digital_text_format(total_seconds)
    hours = total_seconds / 3600
    mins = (total_seconds - hours * 3600) / 60
    seconds = total_seconds - (hours * 3600) - (mins * 60)
    "#{'%02d' % hours}:#{'%02d' % mins}:#{'%02d' % seconds}"
  end
  
  def self.time_in_decimal_hours_format(total_seconds)
    sprintf('%.02f', (total_seconds.to_f / 3600))
  end
end