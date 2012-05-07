require 'my5_tasks'

namespace :subscriptions do
  desc "Renews any recently expired subscriptions."
  task :renew => :environment do
    puts "Searching for expired subscriptions..."
    helper = My5Tasks.new
    helper.renew_expired_subscriptions
  end
  
  desc "Notifies customers two days before they're trial ends."
  task :remind => :environment do
    puts "Searching for expiring trials..."
    helper = My5Tasks.new
    helper.remind_expiring_free_trials
  end
end

namespace :my5 do
  desc "Sends periodical reminders to customers."
  task :send_reminders => :environment do
    puts "Searching for active reminders..."
    task = My5Tasks.new
    total_sent = task.send_email_reminders
    puts "#{total_sent} reminders sent."
  end
end