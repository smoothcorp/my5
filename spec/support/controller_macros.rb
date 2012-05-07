module ControllerMacros
  def login_customer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]

      @refinery_user = Factory(:refinery_user)
      @customer = Factory.create(:customer)
      subscription = Factory.create(:subscription)
      subscription.update_attributes({:customer_id => @customer.id, :status => 1})

      sign_in @refinery_user
      sign_in @customer
    end
  end

  def login_refinery_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      @refinery_user = Factory(:refinery_user)
      sign_in @refinery_user
    end
  end
end