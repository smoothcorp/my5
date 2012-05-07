class EmailsController < ActionController::Base
  require 'net/http' 
  def create
      @email = Email.new(params[:email])
      if verify_recaptcha(:model => @email, :message => "Please re-enter the verification text") && @email.valid?
         unless ContactMailer.new_message(@email).deliver
            render :text => "false"
         end
         render :text => "true"
      else
         render :text => @email.errors.to_json 
      end
  end
end
