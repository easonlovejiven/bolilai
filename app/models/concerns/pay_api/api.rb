module PayApi
  module Api
    include PayApi::Alipay
    include PayApi::Bill99
    include PayApi::Boc
    include PayApi::Ccb
    include PayApi::Cmbc
    include PayApi::Cmbchina
    include PayApi::Comm
    include PayApi::Lakala
    include PayApi::Pab
    include PayApi::Pgs
    include PayApi::Unionpay
    include PayApi::Wechat
    include PayApi::Yeepay

    def self.included(base)
      # base.extend ClassMethods
      #       base.class_eval do
      #         scope :disabled, -> { where(disabled: true) }
      #       end
      #     end
      #
    end

    INDEPENDENT_BANKS = [
        {:name => "alipay", :title => "支付宝", },
        {:name => "bill99", :title => "快钱", },
        {:name => "unionpay", :title => "中国银联", },
        {:name => "unionpay_wap", :title => "中国银联移动支付", },
        {:name => "lakala", :title => "拉卡拉", },
        {:name => "cmbchina", :title => "招商银行", },
        {:name => "ccb", :title => "中国建设银行", },
        {:name => "cmbc", :title => "中国民生银行", },
        {:name => "pab", :title => "平安银行", },
        {:name => "pgs", :title => "海航易支付", },
        {:name => "yeepay", :title => '易宝支付'},
        {:name => "boc_creditcard", :title => "中国银行快捷支付", },
        {:name => "boc", :title => "中国银行", },
        {:name => "comm_creditcard", :title => "交通银行快捷支付", },
        {:name => "cmbchina_creditcard", :title => "招商银行信用卡支付"},
        {:name => "wechat", :title => "微信支付"},
        {:name => "pab_pay", :title => "平安付"},
        {:name => "icbc", :title => "工商银行"},
    ]

    PAYMENT_SERVICES = ([
        {:name => "express", :title => "货到付款", },
        {:name => "giveaway", :title => "余额", },
        {:name => "shop", :title => "店铺", },
        {:name => "alipay_direct", :title => "支付宝_余额支付", },
        {:name => "alipay_moto", :title => "支付宝_快捷支付", },
        {:name => "alipay_installment", :title => "支付宝_分期支付", },
        {:name => "alipay_qr", :title => "支付宝_扫码支付", },
        {:name => "alipay_wallet", :title => "支付宝_移动_钱包支付"},
    ]+INDEPENDENT_BANKS).map { |bank| {bank[:name] => bank[:title]} }.inject({}, &:merge).merge(BILL99_BANKS.map { |bank| {"bill99_#{bank[:name]}" => "快钱_#{bank[:title]}"} }.inject({}, &:merge)).
        merge(ALIPAY_BANKS.map { |bank| {"alipay_#{bank[:name]}" => "支付宝_网银支付_#{bank[:title]}"} }.inject({}, &:merge)).
        merge(ALIPAY_CREDITCARD_BANKS.map { |bank| {"alipay_creditcard_#{bank[:name]}" => "支付宝_快捷支付_#{bank[:title]}"} }.inject({}, &:merge)).
        merge(ALIPAY_INSTALLMENT_BANKS.map { |bank| {"alipay_installment_#{bank[:name]}" => "支付宝_分期支付_#{bank[:title]}"} }.inject({}, &:merge)).
        merge((PayApi::Yeepay::YEEPAY_PREPAID_CARD + YEEPAY_DIRECT_CONNECT_BANK + PayApi::Yeepay::YEEPAY_CREDITCARD_BANK + YEEPAY_BANKS).map { |bank| {"yeepay_#{bank[:name]}" => "易宝_#{bank[:title]}"} }.inject({}, &:merge))
    # module ClassMethods
    def try_query_payment! # :nodoc: all
      return unless self.status == 'pay'

      query_alipay!
      # query_cmbchina!
      # query_ccb!
      # query_bill99!
      # query_unionpay!
      # query_lakala!
      # query_yeepay!
      # query_cmbc!
      # query_pab!
      # query_pab_pay!
      # query_pgs!
      # query_boc_creditcard!
      # query_boc!
      # query_unionpay_wap!
      # query_comm_creditcard!
      # query_cmbchina_creditcard!
      #query_icbc!
    end
    # end
  end
end
