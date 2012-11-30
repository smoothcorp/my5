class Subscription < ActiveRecord::Base
  belongs_to :customer

  scope :active_subscription, where(:status => [1, 2], :expiry_date.gt => Time.now).order('expiry_date DESC').limit(1)
  scope :latest_subscription, order('created_at DESC').limit(1)

  # Validations

  validates :customer_id, :presence => true
  validates :expiry_date, :presence => true
  validates :plan, :presence => true
  validate  :expiry_date_has_not_alredy_past

  def expiry_date_has_not_alredy_past
    if !expiry_date.blank? and expiry_date < Date.today
      errors.add(:expiry_date, "can't be in the past")
    end
  end

  # Class Methods

  def self.recently_expired_subscriptions
    where(:status => 0, :expiry_date => ((Time.now - 1.day)...Time.now))
  end

  def self.free_trials_ending_in_two_days
    where(:status => 2, :expiry_date => ((Time.now + 1.day)...(Time.now + 2.days)))
  end

  def self.free_trial_for(customer_id, trial_period)
    obj = Subscription.new({:customer_id => customer_id, :status => 2})
    obj.add_time(trial_period)
    obj
  end

  def self.yearly_subscription_for(customer_id)
    obj = Subscription.new({:customer_id => customer_id, :status => 1})
    obj.add_time(1.year)
    obj
  end

  # Instance Methods

  def add_time(duration)
    return false unless duration.to_i > 0

    if self.expiry_date.nil?
      self.expiry_date = Time.now
    end

    self.expiry_date += duration
  end

  def important_attributes
    ["customer_id", "expiry_date"].inject({}) { |sum,k| sum[k] = self.attributes[k]; sum }
  end

  def expiry_date_to_s
    return "" if self.expiry_date.nil?
    self.expiry_date.localtime.strftime("%b %d, %Y")
  end

  # Actions

  def expire
    self.update_attribute(:expiry_date, Time.now)
  end

  def renew(time_to_add)
    s = Subscription.new(self.important_attributes)
    s.add_time(time_to_add)
    s
  end

  # Status

  def active?
    self.status == 1
  end

  def free_trial?
    self.status == 2
  end

  def expired?
    self.status == 0
  end

end
