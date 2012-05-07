::Refinery::Application.routes.draw do
  namespace :my5 do
    resources :audio_programs, :only => [:index, :show]
    get 'audio_programs/:id/:audio_id', :controller => "audio_programs", :action => "show_audio", :as => :audio_programs_audio
  end
  
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :audio_programs, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
