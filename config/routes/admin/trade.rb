Weimall::Application.routes.draw do
  namespace :admin do
    namespace :shop do
      resources :trades do
        collection do
          get :inspect_sync
          get :amount_index
          put :amount_update
          get :trades_accounts
          get :search
        end
        member do
          get :lakala_query
          put :receipt
          get :ccb_query
          get :pab_query
          get :bill99_query
          put :return
          get :boc_query
          get :unionpay_query
          put :prepare
          get :edit_prepare
          get :cmbchina_query
          put :freeze
          get :split_new
          put :reject
          put :accept
          put :audit
          get :pgs_query
          get :yeepay_query
          put :sync
          get :show_contribute
          put :split
          get :ship_new
          get :delivery_query
          put :units_return
          get :cmbc_query
          put :receive
          get :print
          put :ship
          get :boc_creditcard_query
          get :invoice_delivery_query
          put :express_pay
          put :try_query
          get :alipay_query
          put :punish
          get :unionpay_wap_query
          get :comm_creditcard_query
          get :cmbchina_creditcard_query
          get :icbc_query
          get :refund_amount
          put :refund_amount_update
          get :wechat_query
          get :pab_pay_query
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
    end
  end
end
