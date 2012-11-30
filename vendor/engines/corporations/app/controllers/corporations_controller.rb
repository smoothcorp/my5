class CorporationsController < ApplicationController

  before_filter :find_all_corporations
  before_filter :find_page

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @corporation in the line below:
    present(@page)
  end

  def show
    @corporation = Corporation.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @corporation in the line below:
    present(@page)
  end

protected

  def find_all_corporations
    @corporations = Corporation.order('position ASC')
  end

  def find_page
    @page = Page.where(:link_url => "/corporations").first
  end

end
