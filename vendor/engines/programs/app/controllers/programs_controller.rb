class ProgramsController < ApplicationController

  before_filter :find_all_programs
  before_filter :find_page

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @program in the line below:
    present(@page)
  end

  def show
    @program = Program.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @program in the line below:
    present(@page)
  end

protected

  def find_all_programs
    @programs = Program.order('position ASC')
  end

  def find_page
    @page = Page.where(:link_url => "/programs").first
  end

end
