Given /^I have no audios$/ do
  Audio.delete_all
end

Given /^I (only )?have audios titled "?([^\"]*)"?$/ do |only, titles|
  Audio.delete_all if only
  titles.split(', ').each do |title|
    Audio.create(:title => title)
  end
end

Then /^I should have ([0-9]+) audios?$/ do |count|
  Audio.count.should == count.to_i
end
