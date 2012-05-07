::Refinery::Application.routes.draw do
  namespace :my5 do
      resources :symptomatics, :only => [:index, :show]
      get "/symptomatics/:id/:condition", :controller => :symptomatics, :action => :show_condition, :as => :condition
      get "/symptomatics/:id/:condition/:video_id", :controller => :symptomatics, :action => :show_video, :as => :symptomatic_video
  end
  
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :symptomatics, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
