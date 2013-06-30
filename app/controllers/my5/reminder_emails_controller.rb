class My5::ReminderEmailsController < ApplicationController
  layout "customer"
  before_filter :authenticate_customer!

  def index
    @reminder_emails = current_customer.reminders.order("time ASC")
  end

  def new
    @reminder_email = current_customer.reminders.build
  end

  def edit
    @reminder_email = current_customer.reminders.find(params[:id])

    @reminder_email.days_of_week_input = @reminder_email.days_of_week.split(',')

    variable = own_time_zones
    if variable[current_customer.time_zone]
      hour_off_set = variable[current_customer.time_zone][0]
      mins_off_set = variable[current_customer.time_zone][1]
      offset = hour_off_set.hour + mins_off_set.minutes
    else
      Time.zone = current_customer.time_zone
      z = Time.zone.now.to_s
      hou = z[-5] + z[-4] + z[-3]
      min = z[0] + z[1]
      offset = min.to_i.minutes
    end

    @reminder_email.time = @reminder_email.time - 10.hours + offset
  end

  def create
    @reminder_email = update_model_with_params(current_customer.reminders.build)
    if @reminder_email.save
      redirect_to my5_reminder_emails_url, :notice => 'Your reminder emails are now setup.'
    else
      flash[:alert] = "You must select one or more days for this reminder."
      render :action => "new"
    end
  end

  def update
    @reminder_email = update_model_with_params(current_customer.reminders.find(params[:id]))
    if @reminder_email.save
      redirect_to my5_reminder_emails_url, :notice => 'Your reminder emails have been altered.'
    else
      flash[:alert] = 'You must select one or more days for this reminder.'
      render :action => "edit"
    end
  end

  def destroy
    @reminder_email = current_customer.reminders.find(params[:id])
    @reminder_email.destroy

    redirect_to my5_reminder_emails_url
  end


  # Workaround for Formtastic + time_of_day time zone ignorance.
  def update_model_with_params(model_obj)

    variable = own_time_zones
     
    if variable[current_customer.time_zone]
      hour_off_set = variable[current_customer.time_zone][0]
      mins_off_set = variable[current_customer.time_zone][1]
      offset = hour_off_set.hour + mins_off_set.minutes
    else


    Time.zone = current_customer.time_zone
 
     z = Time.zone.now.to_s
     hou = z[-5] + z[-4] + z[-3]
     min = z[0] + z[1] 
     offset = min.to_i.minutes

    end
  
     update_params = params[:reminder_email]
     model_obj.days_of_week = update_params[:days_of_week_input].reject(&:blank?).join(',')

     model_obj.time = DateTime.strptime("2009-09-10 #{ update_params['time(4i)'] }:#{ update_params['time(5i)'] }", '%Y-%m-%d %H:%M').to_time - offset
 
     model_obj    
  end

end
