Given /^I have no programs$/ do
  Program.delete_all
end


Then /^I should have ([0-9]+) programs?$/ do |count|
  Program.count.should == count.to_i
end
