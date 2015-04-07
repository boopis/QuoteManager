QuoteManager::Application.routes.draw do

  authenticated :user do
    root 'dashboard#index', as: :subdomain_root
  end
  root 'welcome#index'

  resources :forms
  get '/form-inline/:id' => 'forms#form_inline'
  
  resources :requests do
    get '/download/:field_id', action: :download, as: :download
    patch '/update-note', action: :update_note, as: :update_note
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
  end

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users do
    collection do 
      post :create_user
    end
  end

  resources :templates

  post "payments/hook"
  resources :payments do
    collection do 
      get :new
      post :create
      get :edit
      put :update
      patch :update
    end
  end

  get '/notifications/unread' => 'notifications#unread'
  resources :notifications, only: [:show, :index]
  
  post 'login' => 'accounts#login'
  resources :accounts, except: [:show]
end
