class ContactMailer < ActionMailer::Base

  def new_message(email)
      @email = email

      mail(
        :to => 'mimi.fong@my5.com.au',
        :subject => "My5 Online Contact",
        :from => %("#{@email.contact_name}" <sales@salesleadgenerationaus.com.au>))
  end
end
