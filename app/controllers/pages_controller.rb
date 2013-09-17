class PagesController < ApplicationController
  layout :dynamic_layout
  before_filter :redirect_to_dashboard_if_signed_in
  
  def show
    custom_pages = ["home", "features", "contact_us", "about", "pricing", "faq"]
    @page = Page.find("#{params[:path]}/#{params[:id]}".split('/').last)
    if @page.try(:live?) || (refinery_user? && current_user.authorized_plugins.include?("refinery_pages"))
      # Handle a few custom pages
      if custom_pages.include?(@page.title.downcase.sub(" ","_"))
        render @page.title.downcase.sub(" ","_")
      else
        # if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
        if @page.skip_to_first_child && (first_live_child = @page.children.order('lft ASC').live.first).present?
          redirect_to first_live_child.url and return
        elsif @page.link_url.present?
          redirect_to @page.link_url and return
        end
      end
    else
      error_404
    end
  end
  
  def dynamic_layout
    if current_customer
      "customer"
    else
      "application"
    end
  end
end
