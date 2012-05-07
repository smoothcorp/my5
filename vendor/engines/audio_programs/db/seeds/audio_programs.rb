if defined?(User)
  User.all.each do |user|
    if user.plugins.where(:name => 'audio_programs').blank?
      user.plugins.create(:name => 'audio_programs',
                          :position => (user.plugins.maximum(:position) || -1) +1)
    end
  end
end

if defined?(Page)
  page = Page.create(
    :title => 'Audio Programs',
    :link_url => '/audio_programs',
    :deletable => false,
    :position => ((Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1),
    :menu_match => '^/audio_programs(\/|\/.+?|)$'
  )
  Page.default_parts.each do |default_page_part|
    page.parts.create(:title => default_page_part, :body => nil)
  end
end