Given /^I have no symptomatics$/ do
  Symptomatic.delete_all
end

Given /^I (only )?have symptomatics titled "?([^\"]*)"?$/ do |only, titles|
  Symptomatic.delete_all if only
  titles.split(', ').each do |title|
    Symptomatic.create(:condition => title)
  end
end

Then /^I should have ([0-9]+) symptomatics?$/ do |count|
  Symptomatic.count.should == count.to_i
end
