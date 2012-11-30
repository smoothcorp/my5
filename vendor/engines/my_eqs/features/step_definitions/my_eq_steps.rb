Given /^I have no my_eqs$/ do
  MyEq.delete_all
end

Given /^I (only )?have my_eqs titled "?([^\"]*)"?$/ do |only, titles|
  MyEq.delete_all if only
  titles.split(', ').each do |title|
    MyEq.create(:emotional_grouping => title)
  end
end

Then /^I should have ([0-9]+) my_eqs?$/ do |count|
  MyEq.count.should == count.to_i
end
