require 'factory_girl'

# FactoryGirl.define 
#   factory :user do
#   sequence(:username) { |n| "username#{n}" }
#   sequence(:email) { |n| "email#{n}@google.com" }
#   password               "password"
#   password_confirmation { |u| u.password }

#   factory :refinery_user do
#   roles { [ Role[:refinery] ] }
#   after_create do |user|
#     Refinery::Plugins.registered.each_with_index do |plugin, index|
#       user.plugins.create(:name => plugin.name, :position => index)
#     end
#   end
# end

# FactoryGirl.define :roles_users do |f|
#   f.association :user, :factory => :user
#   f.association :role, :factory => :role
# end

# FactoryGirl.define :role do |f|
#   f.title "Superuser"
# end

# FactoryGirl.define :customer do |f|
#   f.title 'Mr.'
#   f.sequence(:first_name) { |n| "firstname#{n}" }
#   f.sequence(:last_name)  { |n| "lastname#{n}" }
#   f.sequence(:email)      { |n| "customer-test-email#{n}@my5.com.au" }
#   f.password              "password"
#   f.password_confirmation { |u| u.password }
#   f.sequence(:street_1)   { |n| "#{n} Test Lane" }
#   f.street_2              ""
#   f.city                  "Test Town"
#   f.state                 "NSW"
#   f.country               "AU"
#   f.zip_code              "2000"
#   f.card_number           "XXXX-XXXX-XXXX-1234"
#   f.card_expiry_date      "1/2020"
# end

# FactoryGirl.define :corporation do |f|
#   f.sequence(:name) { |n| "corporationname#{n}" }
# end

# FactoryGirl.define :department do |f|
#   f.sequence(:name) { |n| "departmentname#{n}" }
#   f.association :corporation, :factory => :corporation
# end

# FactoryGirl.define :subscription do |f|
#   f.customer_id 1
#   f.expiry_date 5.days.from_now
#   f.plan 1
#   f.status 0
# end

# Factory.define :free_trial_subscription, :class => 'subscription' do |f|
#   f.customer_id 1
#   f.expiry_date 10.days.from_now
#   f.plan 1
#   f.status 2
# end

# Factory.define :health_checkin do |f|
#   f.association :customer, :factory => :customer
# end

# Factory.define :event do |f|
#   f.sequence(:title) { |n| "Event Title #{n}" }
#   f.sequence(:stub) { |n| "event-title-#{n}" }
# end

# Factory.define :occurence do |f|
#   f.session_id "1234"
#   f.association :customer, :factory => :customer
#   f.association :event, :factory => :event
#   f.sequence(:created_at) { |n| (Time.now - (1*n).hours) }
# end

# Factory.define :occurence_alt_session, :parent => :occurence do |f|
#   f.session_id "5678"
#   f.association :customer, :factory => :customer
#   f.association :event, :factory => :event
#   f.sequence(:created_at) { |n| (Time.now - (1*n).hours) }
# end

# Factory.define :occurence_half_days_apart, :parent => :occurence do |f|
#   f.session_id "1234"
#   f.association :customer, :factory => :customer
#   f.association :event, :factory => :event
#   f.sequence(:created_at) { |n| (Time.now - (0.5*n).days) }
# end

# Factory.define :occurence_created_1_week_ago, :parent => :occurence do |f|
#   f.session_id "1234"
#   f.association :customer, :factory => :customer
#   f.association :event, :factory => :event
#   f.created_at (Date.today - 7.days)
# end