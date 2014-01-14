class MainPageContactFormController < ApplicationController
  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request

    if @contact.deliver
      flash[:error] = nil
      flash[:notice] = 'Your message was sent. Thank you!'
    else
      flash[:error] = 'Your message did not send.'
    end
    redirect_to root_path
  end
end
