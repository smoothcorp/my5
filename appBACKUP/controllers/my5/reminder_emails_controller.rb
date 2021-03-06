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
    @reminder_email.time = @reminder_email.time
  end

  def create
    @reminder_email = update_model_with_params(current_customer.reminders.build)
    if @reminder_email.save
      redirect_to my5_reminder_emails_url, :notice => 'Your reminder emails are now setup.'
    else
      render :action => "index"
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
    update_params = params[:reminder_email]
    model_obj.days_of_week = update_params[:days_of_week_input].reject(&:blank?).join(',')
    model_obj.time = Time.zone.parse("#{ update_params['time(4i)'] }:#{ update_params['time(5i)'] }")
    model_obj
  end
end
