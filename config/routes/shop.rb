Weimall::Application.routes.draw do
  namespace :shop do
    root :to => 'pages#show', :id => 'root'
    match 'products/:name' => 'products#index', :name => /latest|hupo|chuanshi|shouzhuo|jiezhi|erhuan|xianglian/, via: "get"
    match 'brands/:where_brand_id' => 'products#index', :constraints => {:format => /html|iphone|ipad|touch/}, via: "get"
    match 'categories/:where_category1_id' => 'products#index', :constraints => {:format => /html|iphone|ipad|touch/}, via: "get"
    resources :brands do
      collection do
        get :top
      end
    end

    resources :products do
      collection do
        get :help
        get :vizury
        get :brands
        get :condition
        get :mall360
        get :tags
        get :mall360storage
        get :baidu_index
        get :sogou_index
        get :sogou
        get :google
        get :latest_products
        get :view_units
      end
      member do
        post :buy
        get :comments
        get :data
      end
      resources :baidu, only: [:show]
      resources :baidu_increment, only: [:show]
    end
    resources :images
    resources :brands do
      collection do
        get :top
      end
    end
    resources :categories do
      collection do
        get :tree
        get :mall360
      end
    end
    resources :trades do
      collection do
        post :update_cart
        post :add_to_cart
        post :mall360
        get :lakala_return
        post :mall360_reconciliation
        get :mall_units_count
        get :payment_success
        get :payment_failure
      end
      member do
        get :boc_return
        post :boc_return
        put :lakala_query
        put :ccb_query
        get :order_new
        put :pab_query
        get :bill99_query
        put :bill99_query
        get :alipay_return
        post :alipay_return
        post :alipay_wallet_return
        put :boc_query
        put :unionpay_query
        get :ccb_return
        get :pay_new
        get :pgs_return
        post :pgs_return
        get :yeepay_return
        post :yeepay_return
        get :zjs_query
        put :cmbchina_query
        post :unionpay_return
        post :icbc_return
        put :icbc_query
        put :contribute
        put :order
        get :contribute_new
        put :pgs_query
        put :yeepay_query
        get :sf_query
        get :cmbchina_return
        post :cmbchina_return
        get :cmbc_return
        put :cancel
        get :boc_creditcard_return
        post :boc_creditcard_return
        get :delivery_query
        get :fedex_query
        put :cmbc_query
        get :checkout
        put :receive
        put :boc_creditcard_query
        get :invoice_delivery_query
        put :express_pay
        get :pab_return
        post :pab_return
        get :bill99_return
        put :alipay_query
        post :unionpay_wap_return
        put :unionpay_wap_query
        get :comm_creditcard_return
        post :comm_creditcard_return
        get :comm_creditcard_return
        put :comm_creditcard_query
        put :texas_holdem_apply
        get :cmbchina_creditcard_return
        put :cmbchina_creditcard_return
        put :cmbchina_creditcard_query
        get :icbc_return
        post :icbc_return
        put :icbc_query
        post :wechat_return
        put :wechat_query
        get :pab_pay_return
        post :pab_pay_return
        put :pab_pay_query
      end
      resources :units do
        member do
          put :contribute
          put :returning
        end
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
    resources :contacts do
      collection do
        post :alipay_return
        get :alipay
        get :options
      end
    end
    resources :units do
      member do
        put :contribute
        put :returning
      end
    end
    resources :categories
    resources :vouchers do
      collection do
        post :exchange
      end
    end
    resources :favorites
  end

  scope module: :custom_page do
    resources :pages
  end
end
