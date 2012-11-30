class ReminderEmailMailer < ActionMailer::Base
  default :from => "friendsofmy5@my5.com.au"

  def reminder(customer)
    @customer = customer
    mail(
      :to => @customer.email,
      :subject => "My 5 Email Reminder")
  end

  class Preview < MailView

    def reminder
      customer = Factory.build(:customer)
      customer.subscriptions << Factory.build(:free_trial_subscription)

      ::ReminderEmailMailer.reminder(customer)
    end
  end
end
