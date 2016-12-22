module PayApi
  module Alipay
    extend ActiveSupport::Concern
    ALIPAY_BANKS = [
        {:name => "icbcbtb", :title => "中国工商银行（B2B）", },
        {:name => "abcbtb", :title => "中国农业银行（B2B）", },
        {:name => "ccbbtb", :title => "中国建设银行（B2B）", },
        {:name => "spdbb2b", :title => "上海浦东发展银行（B2B）", },
        {:name => "bocb2c", :title => "中国银行", },
        {:name => "icbcb2c", :title => "中国工商银行", },
        {:name => "cmb", :title => "招商银行", },
        {:name => "ccb", :title => "中国建设银行", },
        {:name => "abc", :title => "中国农业银行", },
        {:name => "spdb", :title => "上海浦东发展银行", },
        {:name => "cib", :title => "兴业银行", },
        {:name => "gdb", :title => "广东发展银行", },
        {:name => "sdb", :title => "深圳发展银行", },
        {:name => "cmbc", :title => "中国民生银行", },
        {:name => "comm", :title => "交通银行", },
        {:name => "citic", :title => "中信银行", },
        {:name => "hzcbb2c", :title => "杭州银行", },
        {:name => "cebbank", :title => "中国光大银行", },
        {:name => "shbank", :title => "上海银行", },
        {:name => "nbbank", :title => "宁波银行", },
        {:name => "spabank", :title => "平安银行", },
        {:name => "bjbank", :title => "北京银行", },
        {:name => "bjrcb", :title => "北京农村商业银行", },
        {:name => "fdb", :title => "富滇银行", },
        {:name => "comm", :title => "交通银行"},
        {:name => "cmb-debit", :title => "招商银行-借记卡", },
        {:name => "ccb-debit", :title => "中国建设银行-借记卡", },
        {:name => "icbc-debit", :title => "中国工商银行-借记卡", },
        {:name => "comm-debit", :title => "交通银行-借记卡", },
        {:name => "gdb-debit", :title => "广东发展银行-借记卡", },
        {:name => "boc-debit", :title => "中国银行-借记卡", },
        {:name => "ceb-debit", :title => "中国光大银行-借记卡", },
        {:name => "spdb-debit", :title => "上海浦东发展银行-借记卡", },
        {:name => "psbc-debit", :title => "中国邮政储蓄银行-借记卡", },
    ]

    ALIPAY_CREDITCARD_BANKS = [
        {:name => "icbc", :title => "工商银行", },
        {:name => "abc", :title => "农业银行", },
        {:name => "cmb", :title => "招商银行", },
        {:name => "ccb", :title => "建设银行", },
        {:name => "boc", :title => "中国银行", },
        {:name => "sdb", :title => "深圳发展银行", },
        {:name => "ceb", :title => "光大银行", },
        {:name => "spabank", :title => "平安银行", },
    ]

    ALIPAY_INSTALLMENT_BANKS = [
        {:name => "boc-ccip", :title => "中国银行", },
        {:name => "boc-ccip-12", :title => "中国银行(12期)", },
        {:name => "spabank-ccip", :title => "平安银行", },
        {:name => "spabank-ccip-12", :title => "平安银行(12期)", },
        {:name => "abc-ccip", :title => "中国农业银行", },
        {:name => "abc-ccip-12", :title => "中国农业银行(12期)", },
    ]

    def query_alipay! # :nodoc: all
      return false unless self.status == 'pay'

      r = begin
        Timeout::timeout(10) do
          r = HTTParty.get(self.alipay_query_url)
          Rails.logger.info "alipay_query #{r.inspect}"
          r
        end
      rescue Exception => e
        Rails.logger.info "alipay_query_exception #{r.inspect}"
        false
      end

      if r && r['alipay'] && r['alipay']['response'] && r['alipay']['response']['trade'] && %w[TRADE_FINISHED TRADE_SUCCESS].include?(r['alipay']['response']['trade']['trade_status']) && r['alipay']['is_success'] == 'T' && r['alipay']['sign'] == Digest::MD5.hexdigest(r['alipay']['response']['trade'].sort.map { |k, v| "#{k}=#{v}" }.join("&")+PAYMENT_CONFIG['alipay']['key'])
        self.audit!(:payment_service => 'alipay', :payment_identifier => r['alipay']['response']['trade']['trade_no'])
      end
    end

    def alipay_checkout_url(bank = nil, extra_options = {}) # :nodoc: all
      options = {
          'subject' => "#{self.units[0].item.product.name}等#{self.units.count}件",
          'body' => "#{self.identifier}",
          'out_trade_no' => self.id,
          'service' => 'create_direct_pay_by_user',
          'total_fee' => self.payment_price,
          'show_url' => "#{HOSTS['dynamic']}",
          'return_url' => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/alipay_return",
          'notify_url' => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/alipay_return?source=notify",
          'payment_type' => '1',
          'anti_phishing_key' => self.alipay_timestamp,
          'sign_id_ext' => self.user_id,
          'sign_name_ext' => self.user.try(:name),
      }
      case
        when !bank
          options.merge!({
                         })
        when bank == 'direct'
          options.merge!({
                             'paymethod' => 'directPay',
                         })
        when bank == 'moto'
          options.merge!({
                             'paymethod' => 'motoPay',
                             'default_login' => 'Y',
                         })
        when bank == 'wap'
          return alipay_wap_url
        when bank == 'qr'
          options.merge!({
                             'qr_pay_mode' => '2',
                         })
        when bank == 'wallet'
          return alipay_wallet_url(options.slice('subject', 'body', 'out_trade_no', 'total_fee'))
        when m = bank.match(/creditcard_?(.+)/)
          options.merge!({
                             'paymethod' => 'expressGateway',
                             'defaultbank' => m[1].upcase,
                             'default_login' => 'Y',
                         })
        when m = bank.match(/installment_?(.+)?/)
          options.merge!({
                             'paymethod' => 'CCIP',
                             'defaultbank' => m[1].upcase,
                             'default_login' => 'Y',
                         })
        when bank
          options.merge!({
                             'paymethod' => 'bankPay',
                             'defaultbank' => bank.upcase,
                         })
      end
      options.merge!(extra_options)
      alipay_url(options)
    end

    def alipay_query_url # :nodoc: all
      alipay_url 'out_trade_no' => self.id, 'service' => 'single_trade_query'
    end

    def alipay_close_url # :nodoc: all
      alipay_url 'out_order_no' => self.id, 'service' => 'close_trade'
    end

    def alipay_timestamp # :nodoc: all
      Timeout::timeout(10) { HTTParty.get(alipay_url('service' => 'query_timestamp')) }['alipay']['response']['timestamp']['encrypt_key']
    end

    def alipay_address_url(options = {}) # :nodoc: all
      alipay_url 'service' => 'user.logistics.address.query', 'token' => Core::Account.find(options[:user].id).connections.scoped(:conditions => "site = 'alipay'").first.token, 'return_url' => "http://#{HOSTS['dynamic']}/auction/contacts/alipay_return?redirect=#{CGI.escape(options[:redirect])}"
    end


    def send_alipay_shipped
      return unless self.delivery_service.present? && !%w[pickup offline].include?(self.delivery_service)
      options = {
          'service' => 'alipay.logistics.bill.syn',
          'timestamp' => Time.now.to_s(:db),
          'ord_id_ext' => self.id,
          'ord_id' => self.payment_identifier,
          'logistics_bill_no' => self.delivery_identifier,
          'logistics_code' => {'sf' => 'SF', 'zjs' => 'ZJS', 'fedex' => 'FEDEX', 'ems' => 'EMS'}[self.delivery_service],
      }
      response = Nokogiri::XML.parse(Mechanize.new.get(alipay_url(options)).body)
      raise '通知支付宝运单接口提交失败' unless response.xpath('alipay/is_success').text == 'T'
      raise '通知支付宝运单接口验签失败' unless response.xpath('alipay/sign').text == Digest::MD5.hexdigest(response.xpath('alipay/response/LogisticsBillSync').children.to_a.map { |child| {child.try(:name) => child.text} }.inject(&:merge).to_a.sort.map { |k, v| "#{k}=#{v}" }.join("&")+PAYMENT_CONFIG['alipay']['key'])
    rescue => e
      logger.error %[#{e.class.to_s}: #{e.message}\n#{e.backtrace.map { |s| "\tfrom #{s}\n" }.join}]
    end


    def alipay_wallet_url(options)
      options.merge!({
                         'seller' => PAYMENT_CONFIG['alipay']['email'],
                         'partner' => PAYMENT_CONFIG['alipay']['account'],
                         'notify_url' => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/alipay_wallet_return",
                     })
      key = OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['alipay']['client_private_key'])
      options.merge!({
                         'sign_type' => 'RSA',
                         'sign' => CGI::escape(Base64.encode64(key.sign(OpenSSL::Digest::SHA1.new, options.map { |k, v| "#{k}=\"#{v}\"" }.join('&'))).gsub("\n", '')),
                     })
      options.map { |k, v| "#{k}=\"#{v}\"" }.join('&')
    end


    def close_payment # :nodoc: all
      return if self.status == 'pay'

      begin
        Timeout::timeout(10) do
          r = HTTParty.get(self.alipay_close_url)
          Rails.logger.info "alipay_close #{r.inspect}"
        end
      rescue Exception => e
        Rails.logger.info "alipay_close_exception #{e.inspect}"
      end
    end

    private

    def alipay_url(options) # :nodoc: all
      options.merge!({
                         'seller_email' => PAYMENT_CONFIG['alipay']['email'],
                         'partner' => PAYMENT_CONFIG['alipay']['account'],
                         '_input_charset' => 'utf-8',
                     })
      options.merge!({
                         'sign_type' => 'MD5',
                         'sign' => Digest::MD5.hexdigest(options.sort.map { |k, v| "#{k}=#{v}" }.join("&")+PAYMENT_CONFIG['alipay']['key']),
                     })
      action = "https://mapi.alipay.com/gateway.do"
      cgi_escape_action_and_options(action, options)
    end

    def alipay_wap_url
      options = {
          "req_data" => "<direct_trade_create_req><subject>#{self.units[0].item.product.name}等#{self.units.count}件</subject><out_trade_no>#{self.id}</out_trade_no><total_fee>#{format("%.2f", self.payment_price.to_i)}</total_fee><seller_account_name>#{PAYMENT_CONFIG['alipay']['email']}</seller_account_name><notify_url>http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/alipay_return?source=notify</notify_url><merchant_url>#{HOSTS['dynamic']}</merchant_url><call_back_url>http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/alipay_return</call_back_url></direct_trade_create_req>",
          "service" => "alipay.wap.trade.create.direct",
          "format" => 'xml',
          "v" => '2.0',
          "sec_id" => "MD5",
          "partner" => PAYMENT_CONFIG['alipay']['account'],
          "req_id" => self.created_at.strftime("%Y%m%d%H%M%S"),
      }
      options.merge!({
                         'sign' => Digest::MD5.hexdigest(options.sort.map { |k, v| "#{k}=#{v}" }.join("&")+PAYMENT_CONFIG['alipay']['key']),
                     })
      action = "http://wappaygw.alipay.com/service/rest.htm"
      result = Timeout::timeout(30) { HTTParty.get(cgi_escape_action_and_options(action, options)).body }
      tmp_hash = Hash[*result.split('&').map { |x| x.split('=') }.flatten]
      verify_sign = tmp_hash['sign'] == Digest::MD5.hexdigest(tmp_hash.except('sign').sort.map { |k, v| "#{k}=#{CGI::unescape(v.to_s)}" }.join("&")+PAYMENT_CONFIG['alipay']['key'])
      request_token = verify_sign ? Nokogiri::XML.parse(CGI::unescape(tmp_hash["res_data"])).search("request_token").first.content : "签名不正确"
      options = {
          "req_data" => "<auth_and_execute_req><request_token>#{request_token}</request_token></auth_and_execute_req>",
          "service" => "alipay.wap.auth.authAndExecute",
          "format" => 'xml',
          "v" => '2.0',
          "sec_id" => "MD5",
          "partner" => PAYMENT_CONFIG['alipay']['account'],
          "call_back_url" => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/alipay_return",
      }
      options.merge!({
                         'sign' => Digest::MD5.hexdigest(options.sort.map { |k, v| "#{k}=#{v}" }.join("&")+PAYMENT_CONFIG['alipay']['key']),
                     })
      cgi_escape_action_and_options(action, options)
    end
  end
end
