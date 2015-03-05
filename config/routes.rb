QuoteManager::Application.routes.draw do
  authenticated :user do
    root 'dashboard#index', as: :subdomain_root
  end
  root 'welcome#index'
  resources :forms
  get '/form-inline/:id' => 'forms#form_inline'
  post 'quotes/accept/:id' => 'quotes#accept_quote'
  get '/offer/:id' => 'quotes#public'

  resources :requests
  resources :quotes 
  resources :quotes
  resources :contacts
  devise_for :users
  resources :users do
    collection do 
      post :create_user
    end
  end

  post 'login' => 'accounts#login'
  resources :accounts, except: [:show]
end
