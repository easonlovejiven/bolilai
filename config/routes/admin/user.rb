Weimall::Application.routes.draw do
  namespace :admin do
    resources :users do
      collection do
        get :search
        get :batch
        put :batch_update
        get :update_shop_user_password
        put :update_shop_user_password
        get :update_core_account_password
        put :update_core_account_password
      end
      member do
        get :updatings
      end
    end
  end
end
