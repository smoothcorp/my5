Given /^I have no audio_programs$/ do
  AudioProgram.delete_all
end

Given /^I (only )?have audio_programs titled "?([^\"]*)"?$/ do |only, titles|
  AudioProgram.delete_all if only
  titles.split(', ').each do |title|
    AudioProgram.create(:title => title)
  end
end

Then /^I should have ([0-9]+) audio_programs?$/ do |count|
  AudioProgram.count.should == count.to_i
end
