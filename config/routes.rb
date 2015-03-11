QuoteManager::Application.routes.draw do
  authenticated :user do
    root 'dashboard#index', as: :subdomain_root
  end
  root 'welcome#index'
  resources :forms
  get '/form-inline/:id' => 'forms#form_inline'
  post 'quotes/accept/:id' => 'quotes#accept_quote'
  get '/offer/:id' => 'quotes#public'

  post "payments/hook"

  resources :requests do
    get '/download/:field_id', action: :download, as: :download
  end
  resources :quotes 
  resources :contacts
  devise_for :users
  resources :users do
    collection do 
      post :create_user
    end
  end

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
