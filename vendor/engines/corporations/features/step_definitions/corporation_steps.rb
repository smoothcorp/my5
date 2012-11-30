Given /^I have no corporations$/ do
  Corporation.delete_all
end

Given /^I (only )?have corporations titled "?([^\"]*)"?$/ do |only, titles|
  Corporation.delete_all if only
  titles.split(', ').each do |title|
    Corporation.create(:name => title)
  end
end

Then /^I should have ([0-9]+) corporations?$/ do |count|
  Corporation.count.should == count.to_i
end
