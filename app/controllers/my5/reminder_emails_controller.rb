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
    model_obj.time = DateTime.strptime("2009-09-10 #{ update_params['time(4i)'] }:#{ update_params['time(5i)'] }", '%Y-%m-%d %H:%M').to_time - offset


    now_wday = DateTime.strptime("2009-09-10 #{ update_params['time(4i)'] }:#{ update_params['time(5i)'] }", '%Y-%m-%d %H:%M').to_time.wday
    cur_wday = (DateTime.strptime("2009-09-10 #{ update_params['time(4i)'] }:#{ update_params['time(5i)'] }", '%Y-%m-%d %H:%M').to_time - offset).wday

    
    if now_wday > cur_wday
      str_with_dates = update_params[:days_of_week_input].reject(&:blank?)
      str_with_dates = str_with_dates.map do |x|
        x = x.to_i - 1
        x = 6 if x < 0
        x
      end
      str_with_dates = str_with_dates.join(',')

    elsif now_wday < cur_wday
      str_with_dates = update_params[:days_of_week_input].reject(&:blank?)
      str_with_dates = str_with_dates.map do |x|
        x = x.to_i + 1
        x = 6 if x > 0
        x
      end
      str_with_dates = str_with_dates.join(',')
      
    else
      str_with_dates = update_params[:days_of_week_input].reject(&:blank?).join(',')  
    end

    model_obj.days_of_week = str_with_dates

    model_obj
  end

  private
  def own_time_zones
    { "International Date Line West" => [-12, 0], "Midway Island" => [-11, 0], "American Samoa" => [-11, 0], "Hawaii" => [-10, 0], "Alaska" => [-8, 0], "Pacific Time (US & Canada)" => [-8, 0], "Tijuana" => [-7, 0], "Mountain Time (US & Canada)" => [-7, 0], "Arizona" => [-7, 0], "Chihuahua" => [-6, 0], "Mazatlan" => [-6, 0], "Central Time (US & Canada)" => [-5, 0], "Saskatchewan" => [-6, 0], "Guadalajara" => [-5, 0], "Mexico City" => [-5, 0], "Monterrey" => [-5, 0], "Central America" => [-5, 0], "Eastern Time (US & Canada)" => [-5, 0], "Indiana (East)" => [-4, 0], "Bogota" => [-5, 0], "Lima" => [-5, 0], "Quito" => [-5, 0], "Atlantic Time (Canada)" => [-4, 0], "Caracas" => [-4, -30], "La Paz" => [-4, 0], "Santiago" => [-4, 0], "Newfoundland" => [-2, -30], "Brasilia" => [-3, 0], "Buenos Aires" => [-3, 0], "Montevideo" => [-3, 0], "Georgetown" => [-3, 0], "Greenland" => [-3, 0], "Mid-Atlantic" => [-2, 0], "Azores" => [-1, 0], "Cape Verde Is." => [-1, 0], "Dublin" => [0, 0], "Edinburgh" => [1, 0], "Lisbon" => [1, 0], "London" => [1, 0], "Casablanca" => [1, 0], "Monrovia" => [0, 0], "UTC" => [0, 0], "Belgrade" => [2, 0], "Bratislava" => [2, 0], "Budapest" => [2, 0], "Ljubljana" => [2, 0], "Prague" => [2, 0], "Sarajevo" => [2, 0], "Skopje" => [2, 0], "Warsaw" => [2, 0], "Zagreb" => [2, 0], "Brussels" => [2, 0], "Copenhagen" => [2, 0], "Madrid" => [2, 0], "Paris" => [2, 0], "Amsterdam" => [2, 0], "Berlin" => [2, 0], "Bern" => [2, 0], "Rome" => [2, 0], "Stockholm" => [2, 0], "Vienna" => [2, 0], "West Central Africa" => [2, 0], "Bucharest" => [3, 0], "Cairo" => [2, 0], "Helsinki" => [3, 0], "Kyiv" => [3, 0], "Riga" => [3, 0], "Sofia" => [3, 0], "Tallinn" => [3, 0], "Vilnius" => [3, 0], "Athens" => [3, 0], "Istanbul" => [3, 0], "Minsk" => [3, 0], "Jerusalem" => [3, 0], "Harare" => [2, 0], "Pretoria" => [2, 0], "Moscow" => [4, 0], "St. Petersburg" => [4, 0], "Volgograd" => [4, 0], "Kuwait" => [3, 0], "Riyadh" => [3, 0], "Nairobi" => [3, 0], "Baghdad" => [3, 0], "Tehran" => [4, 30], "Abu Dhabi" => [4, 0], "Muscat" => [4, 0], "Baku" => [5, 0], "Tbilisi" => [4, 0], "Yerevan" => [4, 0], "Kabul" => [4, 30], "Ekaterinburg" => [6, 0], "Islamabad" => [5, 0], "Karachi" => [5, 0], "Tashkent" => [5, 0], "Chennai" => [5, 30], "Kolkata" => [5, 30], "Mumbai" => [5, 30], "New Delhi" => [5, 30], "Kathmandu" => [5, 45], "Astana" => [6, 0], "Dhaka" => [6, 0], "Sri Jayawardenepura" => [5, 30], "Almaty" => [6, 0], "Novosibirsk" => [7, 0], "Rangoon" => [6, 30], "Bangkok" => [7, 0], "Hanoi" => [7, 0], "Jakarta" => [7, 0], "Krasnoyarsk" => [8, 0], "Beijing" => [8, 0], "Chongqing" => [8, 0], "Hong Kong" => [8, 0], "Urumqi" => [8, 0], "Kuala Lumpur" => [8, 0], "Singapore" => [8, 0], "Taipei" => [8, 0], "Perth" => [8, 0], "Irkutsk" => [9, 0], "Ulaanbaatar" => [8, 0], "Seoul" => [9, 0], "Osaka" => [9, 0], "Sapporo" => [9, 0], "Tokyo" => [9, 0], "Yakutsk" => [10, 0], "Darwin" => [9, 30], "Adelaide" => [9, 30], "Canberra" => [10, 0], "Melbourne" => [10, 0], "Sydney" => [10, 0], "Brisbane" => [10, 0], "Hobart" => [10, 0], "Vladivostok" => [11, 0], "Guam" => [10, 0], "Port Moresby" => [10, 0], "Magadan" => [12, 0], "Solomon Is." => [11, 0], "New Caledonia" => [11, 0], "Fiji" => [12, 0], "Kamchatka" => [12, 0], "Marshall Is." => [12, 0], "Auckland" => [12, 0], "Wellington" => [12, 0], "Nuku'alofa" => [13, 0], "Tokelau Is." => [13, 0], "Chatham Is." => [12, 45], "Samoa" => [13, 0] }
  end

end
