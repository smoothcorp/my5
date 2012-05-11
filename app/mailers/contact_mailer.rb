class ContactMailer < ActionMailer::Base
  default :from => "friendsofmy5@my5.com.au"
  
  def new_message(email)
      @email = email

      mail(
        :to => ['tim@my5.com.au'],
        :subject => "Someone named #{email.name} has sent a new message.")
  end
end
