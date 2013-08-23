.padded
  - if current_customer.can_view_reports?
    %h2 My 5 internal reports for #{current_customer.corporation.name} #{" > " + current_customer.department.name if current_customer.dept_manager? && current_customer.can_view_reports?}

    %h3 Key statistics for your #{@reportable.class.to_s}
    %ul.stats
      %li
        .number= @reportable.average_login_time_since(30.days.ago) 
        .text Average login time over last 30 days
      %li
        .number= @reportable.average_login_time_since(90.days.ago)
        .text Average login time over last 90 days
    .separator
    %h3 Aggregate charts for your #{@reportable.class.to_s}
    %h4 Time per section over the last 30 days
    #time_per_section_30_days
    = render :partial => "shared/column_chart", :locals => {:axis_labels => ['Four weeks ago', 'Three weeks ago', 'Last week', 'This week'], :data_series_labels => ["Dashboard", "Symptomatics", "Mini Modules", "My EQs", "Audio Programs"], :data_sets => [@time_in_dashboard_30_days, @time_in_symptomatics_30_days, @time_in_mini_modules_30_days, @time_in_my_eqs_30_days, @time_in_audio_programs_30_days], :div => "time_per_section_30_days", :data_type => 'number', :width => 940, :height => 400}


    %h4 Time per section over the last 90 days
    #time_per_section_90_days
    = render :partial => "shared/column_chart", :locals => {:axis_labels => ['Two months ago', 'Last month', 'This month'], :data_series_labels => ["Dashboard", "Symptomatics", "Mini Modules", "My EQs", "Audio Programs"], :data_sets => [@time_in_dashboard_90_days, @time_in_symptomatics_90_days, @time_in_mini_modules_90_days, @time_in_my_eqs_90_days, @time_in_audio_programs_90_days], :div => "time_per_section_90_days", :data_type => 'number', :width => 940, :height => 400}
  
    
    
