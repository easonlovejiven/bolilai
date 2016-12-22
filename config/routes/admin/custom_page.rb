namespace :admin do
  scope module: :custom_page do
    resources :pages do
      collection do
        get :customizer
        get :batch_delete
        delete :destroy
        post :customize
      end
      member do
        put :snapshoot
        put :publish
        put :unpublish
        put :update_batch
        get :delete
        get :preview
      end
    end
  end
  namespace :custom_page do
    resources :pages do
      collection do
        get :customizer
        post :customize
      end
      member do
        put :snapshoot
        put :publish
        put :unpublish
        get :delete
        get :preview
      end
    end
  end
end
