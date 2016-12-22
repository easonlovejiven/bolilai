namespace :admin do
  resources :uploads, only: [:index, :new, :create, :destroy] do
    member do
      get :delete
    end
    collection do
      get :batch_delete
      delete :destroy
    end
  end
end