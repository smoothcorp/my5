module BlogHelper

  def blog_list_archive
    posts = BlogPost.live.select('published_at').all_previous
    return nil if posts.blank?
    html  = ''
    links = []
    years = []

    posts.each do |e|
      links << e.published_at.strftime('%m/%Y')
      years << e.published_at.strftime('%Y')
    end

    years.uniq!
    links.uniq!

    years.each do |year|
      months = []
      links.each do |l|
        months << l.split('/')[0] if l.split('/')[1] == year
      end
      html << '<li class="li_year" >'
      html << year
      html << '<ul style="display:none" >'
      months.each do |m|
        count = BlogPost.live.by_archive(Time.parse(m + '/' + year)).size
        text  = t("date.month_names")[m.to_i] + "(#{count})"
        html << "<li>"
        html << link_to(text, archive_blog_posts_path(:year => year, :month => m))
        html << "</li>"
      end
      html << "</ul>"
      html << "</li>"
    end

    html.html_safe
  end

  def list_recent_articles
    blog_visits = current_customer.customer_visits.where(:controller_name => 'blog/posts').last(5)
    html        = ''
    blog_visits.each do |bv|
      html << "<li>"
      html << link_to("#{bv.conditions}", blog_post_path(bv.show_id))
      html << "</li>"
    end
    html.html_safe
  end

  def search_list(posts)
    html = ''
    if posts.any?
      posts.each do |post|
        html << "<li>"
        html << link_to(post.title, blog_post_path(post.id))
        html << "</li>"
      end
      html.html_safe
    else
      html.html_safe = "Your search - #{params[:search]} - did not match any posts."
    end
  end
end
