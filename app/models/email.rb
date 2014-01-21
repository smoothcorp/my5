class Email 
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    validates_presence_of :company_name, :email, :location,
                          :contact_name, :role, :phone, :comments, :employees_number
    validates :email, :format => {:with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i, :message => "Please enter a valid email"}, :allow_blank => true

    attr_accessor :company_name, :location, :contact_name,
                  :role, :email, :phone, :employees_number, :comments

    def initialize(attributes = {})
        attributes.each do |name, value|
            send("#{name}=", value)
        end
    end
    
    def persisted?
        false
    end
    
end
