class ContactMailer < ActionMailer::Base
  default :to => Proc.new { ["d.connelly@smoothcorporate.com","tim.norris@my5.com.au",
                             "mimi.fong@my5.com.au"] }

  def new_message(email)
      @email = email

      mail(
        :subject => "My5 Online Contact",
        :from => %("#{@email.contact_name}" <tim.norris@my5.com.au>))
  end
end
