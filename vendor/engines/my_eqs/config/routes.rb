::Refinery::Application.routes.draw do
  namespace :my5 do
    resources :my_eqs, :only => [:index, :show]
    match "/my_eqs/:id/:part", :controller => "my_eqs", :action => "show", :as => :my_eq_with_part, :via => :get
  end

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :my_eqs, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
