QuoteManager::Application.routes.draw do
    
    authenticated :user do
      root 'dashboard#index', as: :subdomain_root
    end
    root 'welcome#index'
    resources :forms
    get '/form-inline/:id' => 'forms#form_inline'

    resources :requests
    resources :quotes
    get '/offer/:id' => 'quotes#public'

    resources :contacts
    devise_for :users
    resources :users, only: [:show]

    post 'login' => 'accounts#login'
    resources :accounts, only: [:new, :create]
end
