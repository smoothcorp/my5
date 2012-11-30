class My5::MyEqsController < ApplicationController
  layout "customer"
  before_filter :authenticate_customer!
  before_filter :find_all_my_eqs
  before_filter :find_page
  before_filter :log_events
  before_filter :customer_views

  def index
    @my_eqs = MyEq.all
  end

  def show
    @my_eq = MyEq.find(params[:id])
    @part = params[:part].to_i
    @page_title = MyEq.steps[@part-1] if @part > 0
    if !@my_eq.image.nil? && (@part) == 2
      @page_image = @my_eq.image.url
    elsif @part > 0
      @page_image = MyEq.images[@part-1] 
    else
      @page_image = "my_eqs/head.png"
    end
    case @part
      when 0
        render "program_overview"
      when 1, 5
        render "audio_step"
      when 2
        @column = "step_two"
        render_eq_part(@column)
      when 3
        @column = "step_three"
        render_eq_part(@column)
      when 4
        @column = "step_four"
        render_eq_part(@column)
      else
        render "description"
    end
  end

protected
  def find_all_my_eqs
    @my_eqs = MyEq.order('position ASC')
  end

  def find_page
    @page = Page.where(:link_url => "/my_eqs").first
  end

  def render_eq_part(column)      
    @page_content = @my_eq.send(column.to_sym).html_safe 
    render "normal_step"    
  end
  
  def log_events
    log_event "Accessed My EQs", current_customer
  end
end
