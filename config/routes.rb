Semblance::Application.routes.draw do

# highcharts
  match 'refinery/reports/screen1' => 'refinery/reports#screen_1'
  match 'my5/dashboard/screen1' => 'my5/dashboard#screen_1'
  match 'refinery/reports/update_department' => 'refinery/reports#update_department'
  match 'my5/dashboard/update_department' => 'my5/dashboard#update_department'
  match 'my5_naturally/search' => 'blog/posts#search'

#excel
  match 'refinery/reports/download_excel' => 'refinery/reports#download_excel'
  match 'my5/dashboard/download_excel' => 'my5/dashboard#download_excel'


  devise_for :customers, :controllers => { :registrations => 'customer_registrations', :sessions => 'customer_sessions' }
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

  match 'refinery/customers/bulk-import' => 'refinery/customers#bulk_import', :as => "bulk_import_customers"
  match 'refinery/video_stats' => 'refinery/video_stats#index', :as => "refinery_video_stats"

  if Rails.env.development?
    mount SubscriptionsMailer::Preview => 'subscriptions_mailer'
    mount ReminderEmailMailer::Preview => 'reminder_emails_mailer'
  end

  root :to => "pages#show", :id => "home"
end
