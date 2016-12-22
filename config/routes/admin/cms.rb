namespace :admin do
  namespace :cms do
    resources :categories do
      collection do
        get :batch_delete
        delete :destroy
      end
      member do
        put :publish
        put :unpublish
        get :delete
        get :preview
      end
    end
    resources :pages do
      collection do
        get :batch_delete
        delete :destroy
      end
      member do
        put :publish
        put :unpublish
        get :delete
        get :preview
      end
    end
  end
end
