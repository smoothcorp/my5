class My5::AudioProgramsController < ApplicationController
  layout "customer"
  before_filter :authenticate_customer!
  before_filter :find_all_audio_programs
  before_filter :log_events
  before_filter :customer_views
  def index
  end

  def show
    @audio_program = AudioProgram.find(params[:id])
  end

  def show_audio
    @audio_program = AudioProgram.find(params[:id])
    @audio = Audio.find(params[:audio_id])
    render "show"
  end
  
protected

  def find_all_audio_programs
    @audio_programs = AudioProgram.order('position ASC')
  end
  
  def log_events
    log_event "Accessed Audio Programs", current_customer
  end
end
