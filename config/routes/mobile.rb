get "/" => "custom_page/pages#show", :id => 'mobile_root', constraints: {subdomain: /^m$|^m.malltest$/}
post "retail/carts" => "mobile/carts#create"
get "retail/carts" => "mobile/carts#show"
delete "retail/carts/:id" => "mobile/carts#destroy"
get "about" => "helps/show"
scope module: "mobile", constraints: {subdomain: /^m$|^m.malltest$/} do
  get 'categories/:where_category1_id' => 'products#index'
  resources :categories
  resources :carts
  resources :products
  resources :trades
  resources :contacts
  resources :vouchers
  resources :helps
  resources :favorites
  get "trades/paymode/:id" => "trades#paymode"
  get "/search" => "products#index", constraints: lambda { |request| !request.params[:keyword].blank? }
  get "/search" => "search#index"
  get "/set_cookies" => "home#set_cookies"
  get "/user_center" => "home#user_center"
  get "/loading" => "home#loading"
  get "/logout" => "sessions#destroy"
  namespace :cms do
    resources :categories
    resources :pages
    match "/:cate_name" => "categories#show", via: "get"
  end
  match "*path", to: "cms/categories#show", via: :get, :constraints => lambda { |req|
                 path = req.params[:path].to_s
                 !(path.match(/^assets.*/) || path.match(/^null.*/) || path.match(/^captcha.*/) || path.match(/^themes.*/))
               }
end
