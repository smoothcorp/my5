::Refinery::Application.routes.draw do
  resources :corporations, :only => [:index, :show]

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :corporations, :except => :show do
      collection do
        post :update_positions
      end
    end
    get "deactivate_corp/:id", :controller => "corporations", :action => :deactivate_corp
  end
end
