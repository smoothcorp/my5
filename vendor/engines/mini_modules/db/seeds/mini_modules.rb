if defined?(User)
  User.all.each do |user|
    if user.plugins.where(:name => 'mini_modules').blank?
      user.plugins.create(:name => 'mini_modules',
                          :position => (user.plugins.maximum(:position) || -1) +1)
    end
  end
end

if defined?(Page)
  page = Page.create(
    :title => 'Mini Modules',
    :link_url => '/mini_modules',
    :deletable => false,
    :position => ((Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1),
    :menu_match => '^/mini_modules(\/|\/.+?|)$'
  )
  Page.default_parts.each do |default_page_part|
    page.parts.create(:title => default_page_part, :body => nil)
  end
end