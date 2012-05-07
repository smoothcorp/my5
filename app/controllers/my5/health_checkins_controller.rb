class My5::HealthCheckinsController < ApplicationController
  before_filter :active_subscription_for_customer!
  expose(:health_checkins) {current_customer.health_checkins || []}
  expose(:health_checkin) {current_customer.nil? ? current_customer.health_checkin : HealthCheckin.new(params[:health_checkin])}
  layout 'customer'

  def index
    @health_checkins = health_checkins.where(:status => 1).limit(7)
  end

  def new
    @step = 0
  end

  def create
    case health_checkin.step.to_i
    when 0 || nil
      @step = 1
      health_checkin.step = @step
      render "new"
    when 1
      if params[:commit] == "Back"
        @step = 0
      else
        @step = 2
      end
      health_checkin.step = @step
      render "new"
    when 2
      if params[:commit] == "Back"
        @step = 1
        health_checkin.step = @step
        render "new"
      else
        if health_checkin.save
          health_checkin.update_attribute(:customer_id, current_customer.id)
          redirect_to :action => :index
        else
          render "new"
        end
      end
    else
      render "new"
    end
  end

  def destroy
    unless health_checkins.blank?
      health_checkins.each do |hc|
        hc.update_attribute(:status, 0)
      end
    end
    redirect_to my5_health_checkins_path
  end
end
