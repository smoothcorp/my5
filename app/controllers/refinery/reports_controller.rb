require 'reports/ga_reports'

class Refinery::ReportsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  
  def index
    # Get details for the 30 day oerview reports
    @time_in_dashboard_30_days = time_in_section_30_days("Viewed Dashboard")
    @time_in_symptomatics_30_days = time_in_section_30_days("Accessed Symptomatics")
    @time_in_mini_modules_30_days = time_in_section_30_days("Accessed Mini Modules")
    @time_in_my_eqs_30_days = time_in_section_30_days("Accessed My EQs")
    @time_in_audio_programs_30_days = time_in_section_30_days("Accessed Audio Programs")
    
    # Get details for the 30 day oerview reports
    @time_in_dashboard_90_days = time_in_section_90_days("Viewed Dashboard")
    @time_in_symptomatics_90_days = time_in_section_90_days("Accessed Symptomatics")
    @time_in_mini_modules_90_days = time_in_section_90_days("Accessed Mini Modules")
    @time_in_my_eqs_90_days = time_in_section_90_days("Accessed My EQs")
    @time_in_audio_programs_90_days = time_in_section_90_days("Accessed Audio Programs")
    
    # Get GAnalytics data
    Garb::Session.login('chris@semblancesystems.com','webwiz250')
    profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == 'UA-26361746-1'}
    @overview = GAReports::Overview.results(profile).to_a
    @pageviews = @overview.first.pageviews
    @visitors =  @overview.first.visitors
    @bouncerate = @overview.first.visit_bounce_rate.to_i
    
    # Respond to the difference formats
    respond_to do |format|
      format.html 
      format.csv { render :csv => Customer.all, :style => :brief, :filename => "my5_detailed_user_report_#{Time.now.strftime('%H:%M %b-%d-%Y')}"}
    end
  end
  
  def time_in_section_30_days(section)
    array = Array.new
    [29.days.ago, 20.days.ago, 13.days.ago, 6.days.ago].each_with_index do |date, i|
      if i == 3
        array << Event.time_for_event_with_title_since(section, date, Time.now, 'time_as_hours')
      else
        array << Event.time_for_event_with_title_since(section, date, date + 7.days, 'time_as_hours')
      end
    end
    array
  end
  
  def time_in_section_90_days(section)
    array = Array.new
    [89.days.ago, 59.days.ago, 29.days.ago].each_with_index do |date, i|
      if i == 2
        array << Event.time_for_event_with_title_since(section, date, Time.now, 'time_as_hours')
      else
        array << Event.time_for_event_with_title_since(section, date, date + 7.days, 'time_as_hours')
      end
    end
    array
  end
  
end
