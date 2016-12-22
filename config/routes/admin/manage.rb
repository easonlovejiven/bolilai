namespace :admin do
  root :to => 'application#index'
  namespace :manage do
    root :to => 'application#index'
    resources :sessions, :only => [:new, :create, :destroy] do
      collection do
        get 'new', as: :login
        get 'destroy', as: :logout
      end
    end
    resources :editors, :roles, :grants, :users
    resources :user do
      member do
        get :delete
      end
    end
    resources :editors do
      collection do
        post :activate_mail
      end
      member do
        get :delete
      end
    end
    resources :grants do
      member do
        get :delete
      end
    end
    resources :logs
    resources :users
    resources :sessions
  end
end
