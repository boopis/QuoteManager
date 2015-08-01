QuoteManager::Application.routes.draw do

  authenticated :user do
    root 'dashboard#index', as: :subdomain_root
  end
  root 'welcome#index'

  namespace :admin do
    get '/', action: :index
    post '/deactive/:account_id', action: :deactive, as: :deactive
    post '/active/:account_id', action: :active, as: :active
  end

  resources :forms
  get '/form-inline/:id' => 'forms#form_inline'
  
  resources :requests do
    get '/download/:field_id', action: :download, as: :download
    patch '/update-note', action: :update_note, as: :update_note
    post '/update-state', action: :update_state, as: :update_state
  end

  get '/offer/:id' => 'quotes#public', as: :public_quote
  resources :quotes do
    get '/email-tracking', action: :track_email , as: :email_tracking
    get '/analytics', action: :analytics, as: :analytics
    patch '/update-note', action: :update_note, as: :update_note
    post '/send-quote', action: :send_quote, as: :send
    post '/accept', action: :accept
    post '/decline', action: :decline
  end

  resources :contacts do
    patch '/update-note', action: :update_note, as: :update_note
    get '/send-email', action: :send_email
    post '/send-email', action: :send_email_to_contact, as: :send_email_to_contact
    collection do
      post :import
    end
  end

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users do
    collection do 
      post :create_user
    end
  end

  resources :templates

  resources :payments do
    collection do 
      get :new
      post :create
      get :edit
      put :update
      patch :update
      post :hook
    end
  end

  resources :notifications, only: [:show, :index] do 
    collection do
      get :unread
    end
  end
  
  resources :accounts, except: [:show] do
    collection do
      post :login
    end
  end
end
