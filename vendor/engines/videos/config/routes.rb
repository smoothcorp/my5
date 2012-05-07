::Refinery::Application.routes.draw do
  namespace :my5 do
      resources :videos, :only => [:index, :show]
  end
  
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :videos, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
