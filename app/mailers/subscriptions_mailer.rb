class SubscriptionsMailer < ActionMailer::Base
  default :from => "no-reply@my5.com.au"

  def joined(customer)
    @customer = customer

    mail(
      :to => @customer.email,
      :subject => "Welcome to My 5!")
  end

  def free_trial_expiring_soon(customer)
    @customer = customer

    mail(
      :to => @customer.email,
      :subject => "Your My 5 Trial")
  end

  def created(customer)
    @customer = customer

    mail(
      :to => @customer.email,
      :subject => "Welcome to My 5!")
  end

  def expiring_soon(customer)
    @customer = customer
    @greeting = "Hi"

    mail(
      :to => @customer.email,
      :subject => "Your My 5 subscription is expiring soon.")
  end

  def expired(customer)
    @customer = customer
    @greeting = "Hi"

    mail(
      :to => @customer.email,
      :subject => "Your My 5 subscription has expired.")
  end

  class Preview < MailView

    def joined
      customer = Factory.build(:customer)
      customer.subscriptions << Factory.build(:free_trial_subscription)

      ::SubscriptionsMailer.joined(customer)
    end

    def free_trial_expiring_soon
      customer = Factory.build(:customer)
      customer.subscriptions << Factory.build(:free_trial_subscription)

      ::SubscriptionsMailer.free_trial_expiring_soon(customer)
    end

    def created
      customer = Factory.build(:customer)
      ::SubscriptionsMailer.created(customer)
    end

    def expiring_soon
      customer = Factory.build(:customer)
      ::SubscriptionsMailer.expiring_soon(customer)
    end

    def expired
      customer = Factory.build(:customer)
      ::SubscriptionsMailer.expired(customer)
    end
  end
end
