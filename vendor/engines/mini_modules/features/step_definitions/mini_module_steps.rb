Given /^I have no mini_modules$/ do
  MiniModule.delete_all
end

Given /^I (only )?have mini_modules titled "?([^\"]*)"?$/ do |only, titles|
  MiniModule.delete_all if only
  titles.split(', ').each do |title|
    MiniModule.create(:title => title)
  end
end

Then /^I should have ([0-9]+) mini_modules?$/ do |count|
  MiniModule.count.should == count.to_i
end
