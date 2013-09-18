module BlogHelper
  def list_recent_articles
    blog_visits = current_customer.customer_visits.where(:controller_name => 'blog/posts').last(5)
    html = ''
    blog_visits.each do |bv|
      html << "<li>"
      html << link_to("#{bv.conditions}", blog_post_path(bv.show_id))
      html << "</li>"
    end
    html.html_safe
  end
end
