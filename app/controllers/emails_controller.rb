class EmailsController < ActionController::Base
  require 'net/http'
  include SimpleCaptcha::ControllerHelpers

  def create
    @email = Email.new(params[:email])
    unless simple_captcha_valid?
      render :text => 'captcha_error'
      return
    end
    if @email.valid?
      render :text => "false" unless ContactMailer.new_message(@email).deliver
      render :text => "true"
    else
      render :text => @email.errors.to_json
    end
  end
end
