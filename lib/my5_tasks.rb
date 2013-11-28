class My5Tasks

  def initialize
  end

  def renew_expired_subscriptions
    Subscription.recently_expired_subscriptions.each do |subscription|
      continue unless Customer.exists?(subscription.customer_id)
      customer = subscription.customer

      if customer && customer.renew_subscription && customer.subscriptions.active_subscription.empty?
        customer.process_payment_for_subscription(subscription)
      end
    end
  end

  def remind_expiring_free_trials
    Subscription.free_trials_ending_in_two_days.each do |subscription|
      SubscriptionsMailer.free_trial_expiring_soon(subscription.customer).deliver
    end
  end

  def send_email_reminders
    count = 0
    ReminderEmail.active_in_days_of_week.each do |reminder|

      if reminder.customer
        if reminder.is_in_last_5mins
          puts reminder.customer_id
          reminder.remind
          count += 1
        end
      end
    end
    count
  end

end