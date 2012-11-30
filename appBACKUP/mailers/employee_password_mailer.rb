class EmployeePasswordMailer < ActionMailer::Base
  default :from => "friendsofmy5@my5.com.au"
  
  def new_password(customer, password)
    @customer = customer
    @password = password
    
    mail(
      :to => @customer.email,
      :subject => "Welcome to My 5!")
  end
end
