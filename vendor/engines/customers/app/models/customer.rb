require 'time_helpers'
require 'active_merchant_helper'

class Customer < ActiveRecord::Base
  ## --- POSSIBLE ROLES (configured via CMS)

#  ROLES = %w{Assistant/Admin Customer_support field_expert standard team_leader line_manager manager department_manager general_manager state_manager national_manager global_manager executive}

  ROLES = %w{1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50}

  #DEPARTMENTS = [['Administration',1] ,['Creative Development',2],['Customer Service',3],['Executive Management',4],['Finance',5],['Global Supply Shain',6],['Human Resources',7],['IT',8],['Learning & Development',9],['Maintenance',10],['Marketing',11],['R & D',12],['Sales',13],['Software Development',14]]
DEPARTMENTS = [['1',1] ,['2',2],['3',3],['4',4],['5',5],['6',6],['7',7],['8',8],['9',9],['10',10],['11',11],['12',12],['13',13],['14',14],['15',15],['16',16],['17',17],['18',18],['19',19],['20',20],['21',21],['22',22],['23',23],['24',24],['25',25],['26',26],['27',27],['28',28],['29',29],['30',30],['31',31],['32',32],['33',33],['34',34],['35',35],['36',36],['37',37],['38',38],['39',39],['40',40],['41',41],['42',42],['43',43],['44',44],['45',45],['46',46],['47',47],['48',48],['49',49],['50',50] ]

  ## --- DEVISE
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  ## --- SCOPES
  scope :with_occurences, :include    => :occurences, 
                                :conditions => "occurences.id IS NOT NULL"
  
  ## --- SETUP ACCESS TO THE MODEL
  attr_accessible :title, :first_name, :last_name, :email, :contact_phone, :street_1, :street_2, :city, :state, :country, :zip_code, :role, :corporation_id, :department_id, :password, :password_confirmation, :remember_me, :avatar, :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at, :accept_terms, :free_trial_opted, :time_zone,:promo_code
  acts_as_indexed :fields => [:first_name, :last_name, :email, :contact_phone, :role]

  ## --- VALIDATIONS
  validate :validate_role
  validate :validate_department
  validates :title, :first_name, :last_name, :email, :presence => true, :on => :create
  validates :street_1, :city, :state, :country, :zip_code, :presence => true, :on => :create, :unless => :corporate?
  validates_acceptance_of :accept_terms

  def validate_credit_card_information(credit_card_details)
    is_valid = ActiveMerchantHelper.credit_card_from_details(credit_card_details).valid?

    errors.add(:credit_card, 'is invalid') unless is_valid
    is_valid
  end

  ## --- ASSOCIATIONS
  belongs_to :corporation
  belongs_to :department
  has_many :reminders, :class_name => "ReminderEmail"
  has_many :activities
  has_many :customer_visits
  has_many :transactions
  has_many :subscriptions
  has_many :health_checkins
  has_many :occurences, :foreign_key => :user_id
  has_attached_file :avatar, :styles => {:thumb => "150x150#" }

  ## --- COMMA FOR THE USER REPORT (part of My5 CMS)
  comma do
    id "User System ID"
    title "Title"
    first_name "First Name"
    last_name "Last Name"
    email "Email Address"
    corporation "Corporation" do |corporation| corporation.name unless corporation.nil? end
    corporation? "User type" do |corporation| corporation ? "Corporate" : "Retail" end
    city "Suburb"
    zip_code "Postcode"
    created_at "Signed up" do |date| date.strftime("%e %B %Y") end
    subscriptions "Date subscription started" do |subscriptions| subscriptions.blank? ? "No subscription" : subscriptions.last.created_at.strftime("%e %B %Y") end
    subscriptions "Date subscription ends" do |subscriptions| subscriptions.blank? ? "No subscription" : subscriptions.last.expiry_date.strftime("%e %B %Y") end
    login_time_last_30_days "Login time last 30 days"
    login_time_last_90_days "Login time last 90 days"
    # last_sign_in_at "Last login date" do |login| login.strftime("%e %B %Y") end
    last_login_duration "Last login duration"
    time_in_symptomatics_last_30_days "Time in Symptomatics last 30 days"
    time_in_mini_modules_last_30_days "Time in Mini Modules last 30 days"
    time_in_my_eqs_last_30_days "Time in My EQs 30 days"
    time_in_audio_programs_last_30_days "Time in Audio Programs last 30 days"
    time_in_symptomatics_last_30_days "Time in Symptomatics last 90 days"
    time_in_mini_modules_last_30_days "Time in Mini Modules last 90 days"
    time_in_my_eqs_last_30_days "Time in My EQs last 90 days"
    time_in_audio_programs_last_30_days "Time in Audio Programs last 90 days"
  end


  ## --- ACCESS LEVELS
  def manager?
    self.role == "manager" && self.corporation?
  end

  def dept_manager?
    self.role == "dept_manager" && self.corporation?
  end

  def corporation?
    !self.corporation_id.blank?
  end

  def can_view_reports?
    (self.manager? || self.dept_manager?) && !self.department_id.blank?
  end

  def retail?
    !self.subscriptions.blank? || (self.corporation_id.blank? && !self.new_record?)
  end

  def active?
    self.subscriptions.active_subscription.first || (self.corporation? && self.corporation.active?)
  end

  ## --- TIME IN VARIOUS SECTIONS FOR REPORT
  ## --- Methods that reference the time_for_event_with_title_since method for comma
  def time_in_symptomatics_last_30_days
    time_for_event_with_title_since("Accessed Symptomatics", 30.days.ago)
  end

  def time_in_mini_modules_last_30_days
    time_for_event_with_title_since("Accessed Mini Modules", 30.days.ago)
  end

  def time_in_my_eqs_last_30_days
    time_for_event_with_title_since("Accessed My EQs", 30.days.ago)
  end

  def time_in_audio_programs_last_30_days
    time_for_event_with_title_since("Accessed Audio Programs", 30.days.ago)
  end

  def time_in_symptomatics_last_90_days
    time_for_event_with_title_since("Accessed Symptomatics", 90.days.ago)
  end

  def time_in_mini_modules_last_90_days
    time_for_event_with_title_since("Accessed Mini Modules", 90.days.ago)
  end

  def time_in_my_eqs_last_90_days
    time_for_event_with_title_since("Accessed My EQs", 90.days.ago)
  end

  def time_in_audio_programs_last_90_days
    time_for_event_with_title_since("Accessed Audio Programs", 90.days.ago)
  end

  def time_for_event_with_title_since(event_title, datetime)
    event = Event.find_by_title(event_title)
    if event.blank? || event.nil?
      false
    else
      occurences = self.occurences.where(:event_id => event.id, :created_at.gte => datetime)
      if occurences.blank? || occurences.nil?
        0
      else
        total_seconds = 0
        occurences = self.occurences.where(:event_id => event.id, :created_at.gte => datetime).select("user_id, session_id, MIN(created_at) as min, MAX(created_at) as max").group("session_id")
        occurences.each {|occurence| total_seconds += Time.diff(occurence.min, occurence.max, '%S')[:diff].to_i} unless occurences.blank?
        TimeHelpers.time_in_digital_text_format(total_seconds)
      end
    end
  end


  ## --- LOGIN TIMES FOR REPORT
  ## --- Methods that reference the login_time_since method for comma
  def login_time_last_30_days
    login_time_since(30.days.ago)
  end

  def login_time_last_90_days
    login_time_since(90.days.ago)
  end

  def login_time_since(date)
    TimeHelpers.time_in_digital_text_format(login_time_since_raw_seconds(date))
  end

  def login_time_on(date)
    TimeHelpers.time_in_digital_text_format(login_time_on_raw_seconds(date))
  end

  def login_time_since_raw_seconds(datetime)
    occurences = self.occurences.where(:created_at.gte => datetime)
    if occurences.blank?
      0
    else
      total_seconds = 0
      occurences.collect(&:session_id).uniq.each do |session_id|
        min = occurences.where(:session_id => session_id).minimum("created_at")
        max = occurences.where(:session_id => session_id).maximum("created_at")
        total_seconds += (max - min)
      end
      total_seconds
    end
  end

  def login_time_on_raw_seconds(datetime)
    occurences = self.occurences.where("DATE(created_at) = DATE(?)", datetime) #where(:created_at.gte => (date - 1.day).to_time, :created_at.lte => (date + 1.day).to_time)
    if occurences.blank? || occurences.nil?
      0
    else
      total_seconds = 0
      occurences.collect(&:session_id).uniq.each do |session_id|
        min = occurences.where(:session_id => session_id).minimum("created_at")
        max = occurences.where(:session_id => session_id).maximum("created_at")
        total_seconds += (max - min)
      end
      total_seconds
    end
  end

  ## --- LAST LOGIN DURATION FOR REPORT
  ## ---
  def last_login_duration
    if self.last_session_id
      min = self.occurences.where(:session_id => self.last_session_id).minimum("created_at")
      max = self.occurences.where(:session_id => self.last_session_id).maximum("created_at")
      Time.diff(min, max, '%h:%m:%s')[:diff]
    else
      0
    end
  end

  ## --- UTILITY METHODS
  ## ---

  def display_name
    if (display_name = self.full_name) && !display_name.blank?
      display_name
    else
      self.email
    end
  end

  def full_name
    first_name = self.first_name || ""
    last_name = self.last_name || ""

    "#{first_name} #{last_name}".chomp
  end

  def last_session_id
    last_occurence = self.occurences.last
    last_occurence.blank? ? false : last_occurence.session_id
  end

  def store_eway_customer(credit_card)
    customer_credit_card = ActiveMerchantHelper.credit_card_from_details(credit_card)

    if customer_credit_card.valid?
      config = Payment.config[:eway][Rails.env].symbolize_keys
      gateway = ActiveMerchant::Billing::EwayManagedGateway.new(config)
      response = gateway.store customer_credit_card, {:billing_address => self.billing_address}
      Rails.logger.debug "Response: " + response.message.to_s
      if response.success?
        self.eway_token = response.token
        self.card_number = customer_credit_card.display_number
        self.card_expiry_date = "#{customer_credit_card.expiry_date.month}/#{customer_credit_card.expiry_date.year}"
        self.card_name = customer_credit_card.name

        return true && response.token
      end
    end

    false
  end

  def self.validate_credit_card(credit_card)
    return false unless credit_card.kind_of?(Hash)
    keys = credit_card.keys.collect { |k| k.kind_of?(Symbol) ? k.to_s : k }
    [:name_on_card, :card_number, :expiry_month, :expiry_year, :verification].inject(true) do |sum, k|
      sum = sum && keys.index(k.to_s)
    end
  end

  def process_payment_for_subscription(previous_subscription = nil)
     make_payment =  !self.promo_code.nil? ? Program.second.price : Program.first.price
     payment = Payment.new(:eway_token => self.eway_token, :amount => make_payment)
     if payment.can_process? && payment.process
      s = previous_subscription.kind_of?(Subscription) ? previous_subscription.renew(1.year) : Subscription.yearly_subscription_for(self.id)
      s.save
      payment.update_attribute(:subscription_id, s.id)
      SubscriptionsMailer.created(self).deliver
    end
  end

  def process_payment
    make_payment =  !self.promo_code.nil? ? Program.second.price : Program.first.price
    payment = Payment.new(:eway_token => self.eway_token, :amount => make_payment)
    if !self.free_trial_opted?
      if payment.can_process? && payment.process
        subscription = Subscription.yearly_subscription_for(self.id)
        subscription.save
        payment.update_attribute(:subscription_id, subscription.id)
        SubscriptionsMailer.created(self).deliver
      end
    end
  end


  ## --- UTILITY METHODS
  ## ---
  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
      update_attributes(params)
    else
      super
    end
  end

  def save_without_password
    password_length = 8
    self.password = self.password_confirmation = Devise.friendly_token.first(password_length)
    return self.password
  end

  ## --- COSMETIC METHODS
  ## ---
  def billing_address
    {
      :title    => self.title,
      :address1 => self.street_1,
      :phone    => "",
      :zip      => self.zip_code,
      :city     => self.city,
      :country  => self.country,
      :state    => self.state,
      :mobile   => "",
      :fax      => ""
    }
  end

  private

  ## --- VALIDATION METHODS
  ## ---
  def validate_role
    if self.corporation.blank? && (self.role == "dept_manager" || self.role == "manager")
      errors.add(:role, "can only be applied if the user is a member of a corporation")
    elsif self.department.blank? && self.role == "dept_manager"
      errors.add(:role, "must be assigned a department to be a department manager")
    end
  end

  def validate_department
    if self.corporation.blank? && self.department_id
      errors.add(:department_id, "can only be assigned to a department within their organisation") unless (Department.find(department_id).corporation_id == corporation_id)
    end
  end

  def corporate?
    !self.corporation_id.nil?
  end

  def self.build_from_csv(row)
    cust = Customer.new
    cust.attributes = {
      :title => row[0],
      :first_name => row[1],
      :last_name => row[2],
      :email => row[3],
      :role => row[5],
      :street_1 => row[6],
      :city => row[7],
      :state => row[8],
      :country => row[9],
      :zip_code => row[10],
      :password => row[11],
      :department_id=>row[12]}
      cust.corporation = Corporation.find_by_name(row[4])
    return cust
  end
end
