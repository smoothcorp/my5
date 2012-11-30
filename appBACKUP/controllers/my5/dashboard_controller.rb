class My5::DashboardController < ApplicationController
  layout 'customer'
  before_filter :authenticate_customer!, :only => [:reports]
  before_filter :active_subscription_for_customer!, :only => :customer
  
  def customer
    log_event "Viewed Dashboard", current_customer
  end
  
  def reports
    if current_customer.can_view_reports?

      @reportable = current_customer.dept_manager? ? current_customer.department : current_customer.corporation
      
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
    else
      redirect_to my5_dashboard_customer_path
    end
  end
  
  def time_in_section_30_days(section)
    array = Array.new
    [29.days.ago, 20.days.ago, 13.days.ago, 6.days.ago].each_with_index do |date, i|
      if i == 3
        array << @reportable.average_time_per_event(section, date, Time.now, 'time_as_hours')
      else
        array << @reportable.average_time_per_event(section, date, date + 7.days, 'time_as_hours')
      end
    end
    array
  end
  
  def time_in_section_90_days(section)
    array = Array.new
    [89.days.ago, 59.days.ago, 29.days.ago].each_with_index do |date, i|
      if i == 2
        array << @reportable.average_time_per_event(section, date, Time.now, 'time_as_hours')
      else
        array << @reportable.average_time_per_event(section, date, date + 7.days, 'time_as_hours')
      end
    end
    array
  end
end
