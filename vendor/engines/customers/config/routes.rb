::Refinery::Application.routes.draw do
  resources :customers, :except => [:show, :create, :update, :destroy]
  delete "customers/destroy_corp_customer/:id", :controller => :customers, :action => :destroy_corp_customer, :as => :customers_delete_corp_customer
  post "customers/create_corp_customer", :controller => :customers, :action => :create_corp_customer
  put "customer/update_corp_customer/:id", :controller => :customers, :action => :update_corp_customer, :as => :customers_update_corp_customer

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :customers, :except => :show do
      collection do
        post :update_positions
      end
    end
    get "get_departments/:id", :controller => "customers", :action => :get_departments
  end
end
