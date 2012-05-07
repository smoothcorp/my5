class My5::MiniModulesController < ApplicationController
  layout "customer"
  before_filter :authenticate_customer!
  before_filter :find_all_mini_modules
  before_filter :log_events

  def index
  end

  def show
    @mini_module = MiniModule.find(params[:id])
  end

  def show_video
    @mini_module = MiniModule.find(params[:id])
    @video = Video.find(params[:video_id])
    render "show"
  end
  
protected
  def find_all_mini_modules
    @mini_modules = MiniModule.order('position ASC')
  end
  
  def log_events
    log_event "Accessed Mini Modules", current_customer
  end
end
