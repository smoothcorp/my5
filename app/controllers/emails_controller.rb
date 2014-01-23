class EmailsController < ActionController::Base
  require 'net/http'
  include SimpleCaptcha::ControllerHelpers
  include SimpleCaptcha::ViewHelper

  def create
    @email = Email.new(params[:email])

    if @email.valid?
      unless simple_captcha_valid?
        render :text => 'captcha_error'
        return
      end
      result = ContactMailer.new_message(@email).deliver ? 'true' : 'false'
      render :text => result
      return
    else
      render :text => { :errors => @email.errors }.to_json
      return
      #render :text => @email.errors.to_json
    end

    redirect_to page_path(:id => 'contact-us'),
                :notice => 'Thanks for getting in touch. We will be in contact with you soon.'
  end
end
