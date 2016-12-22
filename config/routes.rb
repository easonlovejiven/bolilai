class ActionDispatch::Routing::Mapper
  def draw(routes_name, namespace_name=nil)
    instance_eval(File.read(Rails.root.join("config/routes", namespace_name.to_s, "#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  draw :upload, :admin
  draw :shop, :admin
  draw :manage, :admin
  draw :trade, :admin
  draw :custom_page, :admin
  draw :user, :admin
  draw :cms, :admin
  draw :mobile
  draw :shop

  resources :uploads, only: [:create, :destroy] do
    collection do
      get :uptoken
      get :avatar_uptoken
      get :file_keys
    end
  end

  scope :path => :core, :as => :core do
    resources :accounts, :controller => 'home/accounts' do
      collection do
        get :captcha_image
        get :validator_simple
        get :password
        post :resend_activation_code
        post :validate_email
        get :find
        post :validate_phone
        # get :simple_captcha_image
        post :validate_captcha
        get :validator_mail
        # get :simple_captcha
        post :validate_registration
        post :reset
        get :validator_phone
      end
      member do
        get :validate_reset_code
        put :activate
        put :update_email_and_password
      end
    end
    resources :connections, :controller => 'home/connections' do
      collection do
        get :current
        get :callback
        post :callback
      end
    end
    resources :sessions, :controller => 'home/sessions'
    resources :reports, :controller => 'home/reports'
  end

  resources :accounts, :controller => 'home/accounts' do
    collection do
      get :captcha_image
      get :validator_simple
      get :password
      post :resend_activation_code
      post :validate_email
      get :find
      post :validate_phone
      get :simple_captcha_image
      post :validate_captcha
      get :validator_mail
      get :simple_captcha
      post :validate_registration
      post :reset
      get :validator_phone
    end
    member do
      get :validate_reset_code
      put :activate
    end
  end

  resources :connections, :controller => 'home/connections' do
    collection do
      get :current
      get :callback
      post :callback
      post :alipay_wallet
    end
  end

  resources :helps, :controller => 'home/helps'
  resources :visits, :controller => 'home/visits'
  resources :sessions, :controller => 'home/sessions'
  resources :reports, :controller => 'home/reports'
  resources :reset, :controller => 'home/reset' do
    collection do
      get :back
    end
  end

  namespace :search do
    root :to => 'products#root'
    resources :products do
      collection do
        get :root
      end
    end
    resources :statistics
  end

  # ### 用户登录、注册
  # resources :users, only: [:update] do
  #   collection do
  #     get :account
  #     get :passwd
  #     post :modify_passwd
  #   end
  # end

  resources :users, :controller => 'home/users' do
    resources :comments, :controller => 'home/comments'
    collection do
      get :city_list
      get :college_list
    end
    member do
      get :point
      post :update, path: 'update'
      get :picture
      put :update_pic
      put :update_avatar
    end

    resources :friends, :controller => 'home/friends' do
      collection do
        get :search
        get :list
        get :star
      end
      member do
        post :poke
        post :create
        post :suggest
        post :block
      end
    end
    resources :lists, :controller => 'home/lists'
  end

  namespace :cms do
    resources :pages
    resources :categories
    ### cms控制
    match "/:cate_name" => "categories#show", via: "get"
  end

  ### 单页面路由
  match 'users/account' => 'users#show', via: 'get'
  match '/simple_captcha/:action' => 'simple_captcha#index', :as => :simple_captcha, :via => "get"
  match '/admin/home', to: 'admin/home#index', via: "get"
  match '/theme(/*path)', to: 'theme/application#index', via: "get"
  match '/image/auction/picture(/*path)', to: "home#cooperation", via: "get"
  root :to => 'custom_page/pages#show', :id => 'root'
  match "*path", to: "cms/categories#show", via: :get, :constraints => lambda { |req|
                 path = req.params[:path].to_s
                 !(path.match(/^assets.*/) || path.match(/^null.*/) || path.match(/^captcha.*/) || path.match(/^themes.*/))
               }
end
