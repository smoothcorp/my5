require 'time_helpers'

class Event < ActiveRecord::Base
  make_permalink :with => :title, :field => :stub
  has_many :occurences
  
  def self.time_for_event_with_title_since(event_title, start_date, end_date=nil, time_format=nil)
    event = Event.find_by_title(event_title)
    end_date = end_date.blank? ? Time.now : end_date
    if event
      total_time = 0
      occurences = event.occurences.where(:created_at.gte => start_date, :created_at.lte => end_date).select("user_id, session_id, MIN(created_at) as min, MAX(created_at) as max").group("session_id")
      occurences.each {|occurence| total_time += Time.diff(occurence.min, occurence.max, '%S')[:diff].to_i} unless occurences.blank?
      # occurences.each {|occurence| total_time += Time.diff(Time.parse(occurence.min), Time.parse(occurence.max), '%S')[:diff].to_i} unless occurences.blank?
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
