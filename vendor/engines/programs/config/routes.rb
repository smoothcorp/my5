::Refinery::Application.routes.draw do
  resources :programs, :only => [:index, :show]

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :programs, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
