namespace :admin do
  namespace :shop do
    resources :users do
      collection do
        get :batch
        put :batch_update
        get :update_auction_user_password
        put :update_auction_user_password
        get :update_core_account_password
        put :update_core_account_password
      end
      member do
        get :updatings
      end
    end
    resources :comments do
      member do
        get :delete
      end
    end
    resources :levels do
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
    resources :user do
      member do
        get :delete
      end
    end
    resources :products do
      collection do
        get :batch_edit
        post :batch_update
        get :error_caches
        post :price_edit
        get :batch_delete
        post :clear
        get :check
        put :publish
        put :unpublish
      end
      member do
        put :publish
        put :sync
        put :unpublish
        get :updatings
        get :delete
        get :preview
      end
    end
    resources :units do
      member do
        get :prepare_audit
        put :freeze
        put :audit
        put :transfer
        put :receive
        get :prepare_transfer
        put :returning
        get :print
      end
    end
    resources :items do
      collection do
        get :batch
        post :batch_create
        post :import
      end
      member do
        put :publish
        put :unpublish
        get :delete
        get :print
      end
    end
    resources :deliveries
    resources :towns do
      member do
        put :publish
        put :unpublish
      end
    end
    resources :provinces do
      member do
        put :publish
        put :unpublish
      end
    end
    resources :cities do
      member do
        put :publish
        put :unpublish
      end
    end
    resources :countries do
      member do
        put :publish
        put :unpublish
      end
    end
    resources :coupons do
      member do
        put :publish
        put :unpublish
        get :delete
      end
    end
    resources :vouchers do
      collection do
        post :import
        get :batch_delete
        delete :destroy
      end
      member do
        get :delete
      end
    end
    resources :categories do
      collection do
        get :preview
      end
      member do
        put :publish
        put :unpublish
        get :delete
      end
    end
    resources :images
    resources :videos
    resources :contacts
    resources :pictures
    resources :brands do
      member do
        put :publish
        put :unpublish
        get :delete
      end
    end
    resources :attributes do
      member do
        put :publish
        put :unpublish
        get :delete
      end
    end
    resources :events do
      member do
        put :publish
        put :unpublish
        get :delete
      end
    end
  end
  resources :contacts
end
