class Contact < MailForm::Base
  attribute :company_name, :validate => true
  attribute :location, :validate => true
  attribute :contact_name, :validate => true
  attribute :role
  attribute :email, :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :phone
  attribute :employees_number
  attribute :comments

  def headers
    {
        :subject => 'My5 Online Contact',
        :to => 'rsk@mailinator.com',
        :from => %("#{name}" <sales@salesleadgenerationaus.com.au>)
    }
  end
end
