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
    @reminder_email.time = @reminder_email.time.localtime
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
    Time.zone = current_customer.time_zone

    update_params = params[:reminder_email]
    model_obj.days_of_week = update_params[:days_of_week_input].reject(&:blank?).join(',')
    model_obj.time = Time.zone.parse("#{ update_params['time(4i)'] }:#{ update_params['time(5i)'] }")

    if Time.zone.name == 'London'
      model_obj.time = "2012-12-13 #{ update_params['time(4i)'] }:#{ update_params['time(5i)'] }".to_datetime - Time.zone.formatted_offset.to_i.hours
    end

    model_obj

  #    Time.zone = current_customer.time_zone
 
  #    z = Time.zone.now.to_s
  #    hou = z[-5] + z[-4] + z[-3]
  #    min = z[-2] + z[-1]
 
  #    offset = hou.to_i.hours + min.to_i.minutes
 
  #    update_params = params[:reminder_email]
  #    model_obj.days_of_week = update_params[:days_of_week_input].reject(&:blank?).join(',')
  #    model_obj.time = Time.zone.parse("#{ update_params['time(4i)'] }:#{ update_params['time(5i)'] }")
  #    model_obj.time = "2012-12-13 #{ update_params['time(4i)'] }:#{ update_params['time(5i)'] }".to_datetime - offset
 
  #    model_obj    
  end
end
