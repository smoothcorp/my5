::Refinery::Application.routes.draw do
  namespace :my5 do
    resources :mini_modules, :only => [:index, :show]
    get 'mini_modules/:id/:video_id', :controller => "mini_modules", :action => "show_video", :as => :mini_module_video
  end
  
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :mini_modules, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
