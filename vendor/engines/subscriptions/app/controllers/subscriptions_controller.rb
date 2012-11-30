class SubscriptionsController < ApplicationController
  layout "customer"
  before_filter :authenticate_customer!
  before_filter :find_all_subscriptions
  before_filter :find_page

  def new
    @subscription = Subscription.new
    @subscription.customer = current_customer
  end

  def index
    present(@page)
  end

  def create
    if result
      redirect_to my5_dashboard_customer_url, :notice => "Your subscription has been updated."
    else
      redirect_to root_url, :alert => "Unable to process subscription payment."
    end
  end

  def show
    @subscription = Subscription.find(params[:id])
    present(@page)
  end

  def save_details_then_process_payment
    credit_card = params[:customer].delete(:credit_card)
    current_customer.update_attributes(params[:customer])

    if current_customer.store_eway_customer(credit_card)
      process_payment
    else
      render 'new'
    end
  end

  def process_payment
    unless current_customer.subscriptions.active_subscription.first
      current_customer.process_payment_for_subscription
    end
    redirect_to dashboard_url, :notice => 'Subscription updated.'
  end

protected

  def find_all_subscriptions
    @subscriptions = Subscription.order('position ASC')
  end

  def find_page
    @page = Page.where(:link_url => "/subscriptions").first
  end

end
