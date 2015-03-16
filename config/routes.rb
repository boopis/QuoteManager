QuoteManager::Application.routes.draw do

  authenticated :user do
    root 'dashboard#index', as: :subdomain_root
  end
  root 'welcome#index'
  resources :forms
  get '/form-inline/:id' => 'forms#form_inline'
  post 'quotes/accept/:id' => 'quotes#accept_quote'
  get '/offer/:id' => 'quotes#public', as: :public_quote
  post "payments/hook"
  
  resources :requests do
    get '/download/:field_id', action: :download, as: :download
    patch '/update-note', action: :update_note, as: :update_note
  end

  resources :quotes do
    post '/send-quote', action: :send_quote, as: :send
    patch '/update-note', action: :update_note, as: :update_note
    get '/email-tracking', action: :track_email , as: :email_tracking
    get '/analytics', action: :analytics, as: :analytics
  end

  resources :contacts do
    patch '/update-note', action: :update_note, as: :update_note
  end

  devise_for :users
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
    end
  end
  
  post 'login' => 'accounts#login'
  resources :accounts, except: [:show]
end
