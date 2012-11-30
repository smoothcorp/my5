if defined?(User)
  User.all.each do |user|
    if user.plugins.where(:name => 'my_eqs').blank?
      user.plugins.create(:name => 'my_eqs',
                          :position => (user.plugins.maximum(:position) || -1) +1)
    end
  end
end

if defined?(Page)
  page = Page.create(
    :title => 'My Eqs',
    :link_url => '/my_eqs',
    :deletable => false,
    :position => ((Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1),
    :menu_match => '^/my_eqs(\/|\/.+?|)$'
  )
  Page.default_parts.each do |default_page_part|
    page.parts.create(:title => default_page_part, :body => nil)
  end
end