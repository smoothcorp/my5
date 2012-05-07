class Email 
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    validates_presence_of :name, :email, :message => "This is a required field"
    validates :email, :format => {:with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i, :message => "Please enter a valid email"}, :allow_blank => true
    validates :name, :format => {:with => /^[a-z ,.'-]+$/i, :message => "Please enter a valid name"}, :allow_blank => true
    
    attr_accessor :message, :name, :email

    def initialize(attributes = {})
        attributes.each do |name, value|
            send("#{name}=", value)
        end
    end
    
    def persisted?
        false
    end
    
end
