Given /^I have no subscriptions$/ do
  Subscription.delete_all
end


Then /^I should have ([0-9]+) subscriptions?$/ do |count|
  Subscription.count.should == count.to_i
end
