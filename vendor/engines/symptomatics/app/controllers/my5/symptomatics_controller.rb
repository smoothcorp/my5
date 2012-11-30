class My5::SymptomaticsController < ApplicationController
  layout "customer"
  before_filter :authenticate_customer!
  before_filter :find_all_symptomatics
  before_filter :log_events
  before_filter :customer_views

  def index
    @body_parts = Symptomatic.body_parts
  end

  def show
    @body_parts = Symptomatic.body_parts
    @symptomatics = Symptomatic.where(:body_part => params[:id].to_i)
  end

  def show_condition
    @condition = Symptomatic.find_by_param(params[:condition])
    redirect_to :index unless @condition
  end
  
  def show_video
    @condition = Symptomatic.find_by_param(params[:condition])
    @video = Video.find(params[:video_id])
    if @condition && @video
      render "show_video"
    else
      redirect_to :index
    end
  end

protected
  def find_all_symptomatics
    @symptomatics = Symptomatic.order('position ASC')
  end

  def log_events
    log_event "Accessed Symptomatics", current_customer
  end
end
