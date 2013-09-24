module BlogHelper

  def blog_list_archive
    posts = BlogPost.live.select('published_at').all_previous
    return nil if posts.blank?
    html  = '<ul class="categories_list" id="archived_posts">'
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
      html << '<li class="li_year item" >'
      html << year
      html << '<ul style="display:none" class="subcat" >'
      months.each do |m|
        count = BlogPost.live.by_archive(Time.parse(m + '/' + year)).size
        text  = t('date.month_names')[m.to_i] + "(#{count})"
        html << "<li class='item'>"
        html << link_to(text, archive_blog_posts_path(:year => year, :month => m))
        html << '</li>'
      end
      html << '</ul>'
      html << '</li>'
    end
    html << '</ul>'

    html.html_safe
  end

  def list_recent_articles
    blog_visits = current_customer.customer_visits.where(:controller_name => 'blog/posts').last(5)
    html        = '<ul class="categories_list" id="recent_articles">'
    blog_visits.each do |bv|
      html << "<li class='item'>"
      html << link_to("#{bv.conditions}", blog_post_path(bv.show_id))
      html << '</li>'
    end
    html << '</ul>'
    html.html_safe
  end

  def blog_post_teaser_enabled?
    BlogPost.teasers_enabled?
  end

  def post_teaser(post,length)
    if post.respond_to?(:custom_teaser) && post.custom_teaser.present?
      post.custom_teaser.html_safe
    else
      truncate(post.body, {
          :length =>  length,
          :preserve_html_tags => true
      }).html_safe
    end
  end
end
