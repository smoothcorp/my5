Semblance::Application.routes.draw do
  devise_for :customers, :controllers => { :registrations => 'customer_registrations'}
  devise_scope :customer do
    post '/customers/confirm_details' => 'customer_registrations#confirm_details', :as => :customer_confirm_details
    get '/customers/success' => 'customer_registrations#confirmed_sign_up', :as => :customer_confirmed_sign_up
    get '/customers/edit/billing_details' => 'customer_registrations#edit_billing_details', :as => :customer_edit_billing_details
    put '/customers/update_billing_details' => 'customer_registrations#update_billing_details', :as => :customer_update_billing_details
    put '/customers/remove_billing_details' => 'customer_registrations#remove_billing_details', :as => :customer_remove_billing_details
    post 'upload_image' => 'customer_registrations#upload_image', :as => :upload_image
  end

  resources :emails, :only => [:create]

  namespace :my5 do
    namespace :dashboard do
      get 'customer'
      get 'reports'
    end
    resources :departments, :except => [:show]
    resources :health_checkins, :except => [:show, :edit, :update]
    resources :reminder_emails, :except => [:show]
  end

  namespace :refinery do
    resources :reports, :only => [:index, :show], :controller => 'reports'
  end

  match 'dashboard' => 'my5/dashboard#customer'

  if Rails.env.development?
    mount SubscriptionsMailer::Preview => 'subscriptions_mailer'
    mount ReminderEmailMailer::Preview => 'reminder_emails_mailer'
  end

  root :to => "pages#show", :id => "home"
end