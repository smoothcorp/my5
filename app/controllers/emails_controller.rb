class EmailsController < ActionController::Base
  require 'net/http'
  include SimpleCaptcha::ControllerHelpers

  def create
    @email = Email.new(params[:email])
    if simple_captcha_valid? && @email.valid?
      render :text => "false" unless ContactMailer.new_message(@email).deliver
      render :text => "true"
    else
      redirect_to page_path(:id => 'contact-us'), :error => 'Please reenter captcha.'
    end
  end
end
