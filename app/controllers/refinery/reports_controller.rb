require 'reports/ga_reports'


class Refinery::ReportsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  helper_method :page_name

  def index


    # Get details for the 30 day oerview reports
    # @time_in_dashboard_30_days = time_in_section_30_days("Viewed Dashboard")
    # @time_in_symptomatics_30_days = time_in_section_30_days("Accessed Symptomatics")
    # @time_in_mini_modules_30_days = time_in_section_30_days("Accessed Mini Modules")
    # @time_in_my_eqs_30_days = time_in_section_30_days("Accessed My EQs")
    # @time_in_audio_programs_30_days = time_in_section_30_days("Accessed Audio Programs")

    # # Get details for the 30 day oerview reports
    # @time_in_dashboard_90_days = time_in_section_90_days("Viewed Dashboard")
    # @time_in_symptomatics_90_days = time_in_section_90_days("Accessed Symptomatics")
    # @time_in_mini_modules_90_days = time_in_section_90_days("Accessed Mini Modules")
    # @time_in_my_eqs_90_days = time_in_section_90_days("Accessed My EQs")
    # @time_in_audio_programs_90_days = time_in_section_90_days("Accessed Audio Programs")

    # # Get GAnalytics data
    # Garb::Session.login('chris@semblancesystems.com','webwiz250')
    # profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == 'UA-26361746-1'}
    # @overview = GAReports::Overview.results(profile).to_a
    # @pageviews = @overview.first.pageviews
    # @visitors =  @overview.first.visitors
    # @bouncerate = @overview.first.visit_bounce_rate.to_i

    # Respond to the difference formats

    @companies = Corporation.all
    @customers_locations = Customer.group("city").collect(&:city)
    @customers_location_states = Customer.group("state").collect(&:state)
    @customers_location_country = Customer.group("country").collect(&:country)
    @locations = []
    @state = []
    @country = []
    @customers_locations.each do |loc|
      @locations.push(loc) if !loc.nil? && loc != "" && !@locations.include?(loc)
    end
    @customers_location_states.each do |loc|
      @state.push(loc) if !loc.nil? && loc != "" && !@state.include?(loc)
    end

    @customers_location_country.each do |loc|
      @country.push(loc) if !loc.nil? && loc != "" && !@country.include?(loc)
    end

    list_of_pages
    params[:graph_view] = "1"
    params[:page]="all"
    @reports = filter_screen1
    @side_data = []
    screen_1_data

    respond_to do |format|
      format.html
      format.csv { render :csv => Customer.all, :style => :brief, :filename => "my5_detailed_user_report_#{Time.now.strftime('%H:%M %b-%d-%Y')}" }
    end
  end

  def screen_1
    list_of_pages
    @side_data = []

    @reports = filter_screen1

    if params["graph_view"] == "1"
      screen_1_data
    end

    if params["graph_view"] == "2"
      screen_2_data
    end

    if params["graph_view"] == "3"
      screen_3_data
    end

    respond_to do |format|
      format.js
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


  def update_department
    @corporation = Corporation.find(params[:company_id])
    @departments = @corporation.departments.map { |department| [department.name, department.id] }.insert(0, ["", ""])
    respond_to do |format|
      format.js
    end
  end

  def download_excel
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => "details"
    sheet.row(0).concat %w{User_System_ID Title First_Name Last_Name Corporation User_type Suburb Postcode Signed_up Date_subscription_started,Date_subscription_ends,Login_Time_Last_30_Days,Login_Time_Last_90_Days,Last_login_duration,Time_in_Symptomatics_last_30_days,Time_in_Mini_Modules_last_30_days,Time_in_My_EQs_30_days,Time_in_Audio_Programs_last_30_days,Time_in_Symptomatics_last_90_days,Time_in_Mini_Modules_last_90_days,Time_in_My_EQs_90_days,Time_in_Audio_Programs_last_90_days }
    @custmer = Customer.all
    count = 1
    @custmer.each do |custmer|
      sheet.row(count.to_i).push custmer.id, custmer.title, custmer.first_name, custmer.last_name, custmer.first_name, "#{custmer.corporation.name if !custmer.corporation.nil?}", "#{!custmer.corporation.nil? ? 'Corporate' : 'Retail' }", custmer.city, custmer.zip_code, custmer.created_at.strftime("%e %B %Y"), "#{custmer.subscriptions.blank? ? 'No subscription' : custmer.subscriptions.last.expiry_date.strftime('%e %B %Y')}", custmer.login_time_last_30_days, custmer.login_time_last_30_days, custmer.login_time_last_90_days, custmer.last_login_duration, custmer.time_in_symptomatics_last_30_days, custmer.time_in_mini_modules_last_30_days, custmer.time_in_my_eqs_last_30_days, custmer.time_in_audio_programs_last_30_days, custmer.time_in_symptomatics_last_90_days, custmer.time_in_mini_modules_last_90_days, custmer.time_in_my_eqs_last_90_days, custmer.time_in_audio_programs_last_90_days
      count = count.to_i + 1
    end
    spreadsheet = StringIO.new
    book.write spreadsheet
    send_data spreadsheet.string, :filename => "my5_detailed_user_report_#{Time.now.strftime('%H:%M %b-%d-%Y')}.xls", :type => "application/vnd.ms-excel"
  end

  protected

  def filter_screen1
    case page_name
      when "symptomatics"
        return @reports = filter_query("my5/symptomatics")
      when "mini_modules"
        return @reports = filter_query("my5/mini_modules")
      when "my_eqs"
        return @reports = filter_query("my5/my_eqs")
      when "audio_programs"
        return @reports = filter_query("my5/audio_programs")
      when "health_checkins"
        return @reports = filter_query("my5/health_checkins")
      else
        if @is_condition || (!@customer_ids.nil? && !@customer_ids.blank?)
          @reports = CustomerVisit.where(:customer_id => @customer_ids).where("(Date(created_at) between ? and ?)", @from_date.to_date, @to_date.to_date)
        else
          @reports = CustomerVisit.find(:all, :conditions => ["Date(created_at) between ? and ?", @from_date.to_date, @to_date.to_date])
        end
        @custmer_visit = @reports
        return @reports
    end
  end

  def filter_query(page)
    if @is_condition || (!@customer_ids.nil? && !@customer_ids.blank?)
      @custmer_visit = CustomerVisit.where(:customer_id => @customer_ids).where("(Date(created_at) between ? and ?)", @from_date.to_date, @to_date.to_date).where(:controller_name => page)
    else
      @custmer_visit = CustomerVisit.where("(Date(created_at) between ? and ?)", @from_date.to_date, @to_date.to_date).where(:controller_name => page)
    end

    # Rails.logger.info '>'*150
    # Rails.logger.info '+- Wrong condition -+'
    ### Rails.logger.info @custmer_visit.select { |report| report.show_id.to_i == params[:page_id].to_i && report.media_id == nil }
    # Rails.logger.info @custmer_visit.select { |report| report.show_id.to_i == params[:page_id].to_i && report.media_id }
    # Rails.logger.info '+-'*70

    if !params[:page_id].blank?
      if !params[:video_id].blank?
        @reports = @custmer_visit.select { |report| report if report.show_id.to_i == params[:page_id].to_i && report.media_id.to_i == params[:video_id].to_i }
        # Rails.logger.info '='*150
        # Rails.logger.info @reports.count
        # Rails.logger.info '-'*150
        # Rails.logger.info '-'*150

        # This flag only for My EQ ( Hack )
        $flag = false
        if @reports.count == @reports.reject { |x| x.part.nil? }.count
          $flag = true
        end

        # Rails.logger.info @reports.count
        # Rails.logger.info @reports.reject { |x| x.part.nil? }.count
        # Rails.logger.info '-'*150
        # Rails.logger.info '-'*150
      else
        @reports = @custmer_visit.select { |report| report if report.show_id.to_i == params[:page_id].to_i }
      end
    else
      @reports = @custmer_visit
    end
    # Rails.logger.info '-'*150
    # Rails.logger.info @reports.count
    # Rails.logger.info @reports

    return @reports
  end

  def list_of_pages
    @symptomatics = Symptomatic.all
    @mini_modules = MiniModule.all
    @my_eqs = MyEq.all
    @audio_programs = AudioProgram.all
    if !params[:from_date].blank? && !params[:to_date].blank?
      @from_date = params[:from_date].to_date
      @to_date = params[:to_date].to_date
    else
      @from_date = Time.now - 6.days
      @to_date = Time.now
    end
    @is_condition = false
    customer_condition = ""
    @customer_ids = []
    if !params[:company_id].blank?
      customer_condition = "corporation_id = '#{params[:company_id].to_s}'  "
      @is_condition = true
    end
    if !params[:department_id].blank?
      customer_condition += @is_condition ? " AND " : ""
      customer_condition += "department_id = '#{params[:department_id].to_s}'  "
      @is_condition = true
    end
    if !params[:location].blank?
      customer_condition += @is_condition ? " AND " : ""
      customer_condition += "city LIKE '%#{params[:location].to_s}%' "
      @is_condition = true
    end
    if !params[:role].blank?
      customer_condition += @is_condition ? " AND " : ""
      customer_condition += "role = '#{params[:role].to_s}'"
      @is_condition = true
    end
    if !params[:state].blank?
      customer_condition += @is_condition ? " AND " : ""
      customer_condition += "state LIKE '%#{params[:state].to_s}%' "
      @is_condition = true
    end
    if !params[:country].blank?
      customer_condition += @is_condition ? " AND " : ""
      customer_condition += "country = '#{params[:country].to_s}'"
      @is_condition = true
    end
    if @is_condition
      @customers = Customer.where(customer_condition)
      if !@customers.blank? && !@customers.nil?
        @customer_ids = @customers.collect(&:id)
      end
    end

  end

  def screen_1_data
    @report_day_array = ""
    @report_day_date = ""

    @report_day_array_array = Array.new()

    Rails.logger.info '==='*20
    Rails.logger.info @report_day_array_array
    Rails.logger.info '==='*20

    count = 0

    #Rails.logger.info '#'*1000
    #Rails.logger.info @from_date.to_date
    #Rails.logger.info @to_date.to_date

    (@from_date.to_date..@to_date.to_date).each do |date_t|
      if count == 0
        @report_day_array = "["
        @report_day_date = "["
      else
        @report_day_array += ", "
        @report_day_date += ","
      end

      if page_name =="all"
        if  @is_condition || (!@customer_ids.nil? && !@customer_ids.blank?)
          @day_count = CustomerVisit.where("Date(created_at)= ?", date_t.to_date).where(:customer_id => @customer_ids)
        else
          @day_count = CustomerVisit.where("Date(created_at)= ?", date_t.to_date)
        end
      else
        if @is_condition || (!@customer_ids.nil? && !@customer_ids.blank?)
          if !params[:page_id].blank?
            if !params[:video_id].blank?
              @day_count = CustomerVisit.where("Date(created_at)= ?", date_t.to_date).where(:customer_id => @customer_ids).where(:controller_name => "my5/#{page_name}").where(:show_id => params[:page_id]).where(:media_id => params[:video_id])
            else
              @day_count = CustomerVisit.where("Date(created_at)= ?", date_t.to_date).where(:customer_id => @customer_ids).where(:controller_name => "my5/#{page_name}").where(:show_id => params[:page_id])
            end
          else
            @day_count = CustomerVisit.where("Date(created_at)= ?", date_t.to_date).where(:customer_id => @customer_ids).where(:controller_name => "my5/#{page_name}")
          end
        else
          if !params[:page_id].blank?
            if !params[:video_id].blank?
              @day_count = CustomerVisit.where("Date(created_at)= ?", date_t.to_date).where(:controller_name => "my5/#{page_name}").where(:show_id => params[:page_id]).where(:media_id => params[:video_id])

              # Hack for MyEQ/../Stop! Take a breath in, Pressure point  ( correct graphs for this subparagraphs)
              if $flag
                @day_count = CustomerVisit.where("Date(created_at)= ?", date_t.to_date).where(:controller_name => "my5/#{page_name}").where(:show_id => params[:page_id]).where(:part => params[:video_id])
              end
            else
              @day_count = CustomerVisit.where("Date(created_at)= ?", date_t.to_date).where(:controller_name => "my5/#{page_name}").where(:show_id => params[:page_id])
            end
          else
            @day_count = CustomerVisit.where("Date(created_at)= ?", date_t.to_date).where(:controller_name => "my5/#{page_name}")
          end
        end
      end
      date_string = "'#{date_t.strftime("%Y %m %d").to_s}'"

      #@report_day_array_array << @day_count.size
      #
      #Rails.logger.info '+++'*20
      #Rails.logger.info @report_day_array_array
      #Rails.logger.info '+++'*20

      @report_day_array += @day_count.size.to_s
      @report_day_date += date_string
      count = count + 1



      #Rails.logger.info '*'*400
      #Rails.logger.info "'#{date_t.strftime("%d %B").to_s}'"
    end
    @report_day_array += "]" if !@report_day_array.blank?
    @report_day_date += "]" if !@report_day_date.blank?



    #Rails.logger.info '#'*1000
    #Rails.logger.info @report_day_array
    #Rails.logger.info @report_day_array_array
    #Rails.logger.info '#'*1000


    #@year  = @report_day_date[2..5].to_i
    #@month = @report_day_date[7..8].to_i - 1
    #@day   = @report_day_date[10..11].to_i

    #Rails.logger.info '='*50
    #Rails.logger.info @year
    #Rails.logger.info @month
    #Rails.logger.info @day
    #Rails.logger.info '='*50
    #
    #
    if params[:frequency]
      @round = params[:frequency].to_i
    else
      @round = 1
    end
    #
    #@brr = []
    #avarage = 0
    #
    #@report_day_array_array.reverse.each_slice(@round) do |sub_arr|
    #
    #  Rails.logger.info '#'*100
    #  Rails.logger.info sub_arr
    #  Rails.logger.info '#'*100
    #
    #  sub_arr.each do |x|
    #    avarage += x
    #  end
    #
    #  @brr << avarage
    #  avarage = 0
    #end
    #
    ##Rails.logger.info '#'*1000
    ##Rails.logger.info @brr    # => 2022 2036 1261 597 550
    ##Rails.logger.info @report_day_array
    #
    #if @brr.size > 7
    #  @brr = @brr[0..6]
    #
    #  #Rails.logger.info '#'*1000
    #  #Rails.logger.info @brr
    #
    #  data_to = params[:to_date]
    #  data_to = data_to.split('-')
    #  data_to = (Date.new(data_to[2].to_i, data_to[1].to_i, data_to[0].to_i) - (6 * @round).day).strftime('%Y-%m-%d')
    #  data_to = data_to.split('-')
    #  @year  = data_to[0].to_i
    #  @month = data_to[1].to_i - 1
    #  @day   = data_to[2].to_i
    #
    #  #Rails.logger.info '#'*1000
    #  #Rails.logger.info data_to
    #  #Rails.logger.info @year
    #  #Rails.logger.info @month
    #  #Rails.logger.info @day
    #  #Rails.logger.info '#'*100
    #end
    #
    ##@report_day_array = @brr.reverse
  end

  def screen_2_data
    @part_of_24 = ['12am - 1am', '1am - 2am', '2am - 3am', '3am - 4am', '4am - 5am', '5am - 6am', '6am - 7am', '7am - 8am', '8am - 9am', '9am - 10am', '10am - 11am', '11am - 12pm', '12pm -  1 pm', '1pm - 2pm', '2pm - 3pm', '3pm - 4pm', '4pm - 5pm', '5pm - 6pm', '6pm - 7pm', '7pm - 8pm', '8pm - 9pm', '9pm - 10pm', '10pm - 11pm', '11pm - 12am']
    @array_of_24 = []
    (0..23).each do |number|
      @array_of_24[number] = 0
    end
    if !@reports.blank?
      @reports.each do |visit|
        date = visit.created_at.strftime("%H").to_i
        @array_of_24[date] = @array_of_24[date] + 1
      end
    end
    @report_day_array = "["
    @report_day_date = "["
    @array_of_24.each_with_index do |item, index|
      if index == 0
        @report_day_array = "["
        @report_day_date = "["
      else
        @report_day_array += ", "
        @report_day_date += ","
      end
      @report_day_array += item.to_s
      @report_day_date += "'#{@part_of_24[index]}'"
    end
    @report_day_array += "]"
    @report_day_date += "]"
    @pie_graph_view_data = "["
    @pie_sum_totals = @array_of_24.sum
    if @pie_sum_totals > 0
      @array_of_24.each_with_index do |data, index|
        percentage = (data.to_f/@pie_sum_totals)*100
        @pie_graph_view_data += "['#{@part_of_24[index]}',#{percentage} ]"
        @pie_graph_view_data += "," if ((index+1) != @array_of_24.size)
      end
    end
    @pie_graph_view_data += "]"
  end

  def screen_3_data
    @symo_count = []
    @mini_count = []
    @myq_count = []
    @audio_count = []
    @health_count = []
    @unique_visits = @reports.group_by { |t| t.customer_id }

    # for symptomatics
    if page_name == "all" || page_name == "symptomatics"
      @temp1 = @reports.select { |t| t if t.controller_name == "my5/symptomatics" && t.show_id.nil? }
      @symo_count.push(@temp1.size)
      if !@symptomatics.blank?
        @symptomatics.each do |symto|
          @temp1 = @reports.select { |t| t if t.controller_name == "my5/symptomatics" && t.show_id == symto.id }
          @symo_count.push(@temp1.size)
        end
      end
    end

    # for mini_modules
    if page_name == "all" || page_name == "mini_modules"
      @temp1 = @reports.select { |t| t if t.controller_name == "my5/mini_modules" && t.show_id.nil? }
      @mini_count.push(@temp1.size)
      if !@mini_modules.blank?
        @mini_modules.each do |mini|
          @temp1 = @reports.select { |t| t if t.controller_name == "my5/mini_modules" && t.show_id == mini.id }
          @mini_count.push(@temp1.size)
        end
      end
    end


    # for myq
    if page_name == "all" || page_name == "my_eqs"
      @temp1 = @reports.select { |t| t if t.controller_name == "my5/my_eqs" && t.show_id.nil? }
      @myq_count.push(@temp1.size)
      if !@my_eqs.blank?
        @my_eqs.each do |myq|
          @temp1 = @reports.select { |t| t if t.controller_name == "my5/my_eqs" && t.show_id == myq.id }
          @myq_count.push(@temp1.size)
        end
      end
    end


    # for audio.program
    if page_name == "all" || page_name == "audio_programs"
      @temp1 = @reports.select { |t| t if t.controller_name == "my5/audio_programs" && t.show_id.nil? }
      @audio_count.push(@temp1.size)
      if !@audio_programs.blank?
        @audio_programs.each do |audio_program|
          @temp1 = @reports.select { |t| t if t.controller_name == "my5/audio_programs" && t.show_id == audio_program.id }
          @audio_count.push(@temp1.size)
        end
      end
    end

    #for heath checking
    if page_name == "all" || page_name == "health_checkins"
      @temp1 = @reports.select { |t| t if t.controller_name == "my5/health_checkins" && t.show_id.nil? }
      @health_count.push(@temp1.size)
    end

    @last_count = []
    @last_count[0] = 0
    (1..11).each do |temp|
      @last_count[temp] = 0
    end


    if page_name == "all" || page_name == "symptomatics"
      if !@symo_count.blank?
        @symo_count.each do |val|
          if val > 8 && val < 15
            @last_count[9] = @last_count[9] + 1
          elsif val >= 15 && val < 26
            @last_count[10] = @last_count[10] + 1
          elsif val >= 25
            @last_count[11] = @last_count[11] + 1
          else
            @last_count[val] = @last_count[val] + 1
          end
        end
      end
    end
    if page_name == "all" || page_name == "mini_modules"
      if !@mini_count.blank?
        @mini_count.each do |val|
          if val > 8 && val < 15
            @last_count[9] = @last_count[9] + 1
          elsif val >= 15 && val < 26
            @last_count[10] = @last_count[10] + 1
          elsif val >= 25
            @last_count[11] = @last_count[11] + 1
          else
            @last_count[val] = @last_count[val] + 1
          end
        end
      end
    end
    if page_name == "all" || page_name == "my_eqs"
      if !@myq_count.blank?
        @myq_count.each do |val|
          if val > 8 && val < 15
            @last_count[9] = @last_count[9] + 1
          elsif val >= 15 && val < 26
            @last_count[10] = @last_count[10] + 1
          elsif val >= 25
            @last_count[11] = @last_count[11] + 1
          else
            @last_count[val] = @last_count[val] + 1
          end
        end
      end
    end
    if page_name == "all" || page_name == "audio_programs"
      if !@audio_count.blank?
        @audio_count.each do |val|
          if val > 8 && val < 15
            @last_count[9] = @last_count[9] + 1
          elsif val >= 15 && val < 26
            @last_count[10] = @last_count[10] + 1
          elsif val >= 25
            @last_count[11] = @last_count[11] + 1
          else
            @last_count[val] = @last_count[val] + 1
          end
        end
      end
    end
    if page_name == "all" || page_name == "health_checkins"
      if !@health_count.blank?
        @health_count.each do |val|
          if val > 8 && val < 15
            @last_count[9] = @last_count[9] + 1
          elsif val >= 15 && val < 26
            @last_count[10] = @last_count[10] + 1
          elsif val >= 25
            @last_count[11] = @last_count[11] + 1
          else
            @last_count[val] = @last_count[val] + 1
          end
        end
      end
    end
    @last_count[0] = 0
    @data_view = ['', 1, 2, 3, 4, 5, 6, 7, 8, '9-14', '15-25', '26-50+']
    if !@last_count.nil? && !@last_count.blank?

      @percentage_data = "["
      @page_1 = "["
      @page_2 = "["
      @page_data = "["
      @page_total = @last_count.sum
      if @page_total > 0
        @last_count.each_with_index do |data, index|
          if index != 1 && index != 0
            @page_1 += ","
            @page_2 += ","
            @page_data += ","
          end
          if index > 0
            per = (data.to_f/@page_total.to_f)*100
            @percentage_data += "['#{@data_view[index]}',#{per.round(2)} ]"
            @page_1 += "'#{@data_view[index]}'"
            @page_2 += "#{per.round(0)}"
            @page_data += "#{data}"
            @percentage_data += "," if ((index+1) != @last_count.size)
          end
        end
      end
      @page_1 += "]"
      @page_2 += "]"
      @page_data += "]"
      @percentage_data += "]"
    end


  end

  def page_name
    params[:page] && (params[:page] == 'all') ? params[:page] : params[:page].pluralize
  end

end
