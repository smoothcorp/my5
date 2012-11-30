class Ability
  include CanCan::Ability

  def initialize(customer)
    customer ||= Customer.new # guest user (not logged in)
    
    # Allow editing and creating over users by department and other managers
    if customer.manager?
      can :manage, Customer, :corporation_id => customer.corporation_id
      can :manage, Department, :corporation_id => customer.corporation_id
    elsif customer.dept_manager?
      can :manage, Customer, :corporation_id => customer.corporation_id, :department_id => customer.department_id
    else
      alias_action :update, :to => :modify_self
      can :modify_self, Customer, :id => customer.id
    end
  end
end
