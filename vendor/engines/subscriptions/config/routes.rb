::Refinery::Application.routes.draw do
  resources :subscriptions, :path => '/my5/subscriptions', :only => [:new, :create, :destroy]
  namespace :subscriptions, :path => '/my5/subscriptions' do
    put 'save_details_then_process_payment'
    get 'process_payment'
  end

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :subscriptions, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
