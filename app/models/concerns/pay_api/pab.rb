module PayApi
  module Pab
    def query_pab! # :nodoc: all
      return false unless self.status == 'pay'
      r = self.pab_result
      self.audit!(:payment_service => "pab") if r && r['tranStat'] == '1' && r['orderAmt'].to_f == self.payment_price
    end

    def query_pab_pay! # :nodoc: all
      return false unless self.status == 'pay'
      r = self.pab_pay_result
      self.audit!(:payment_service => "pab_pay") if r && r[:orderStatus] == '00' && r[:orderAmount].to_f == self.payment_price*100
    end

    def pab_checkout_url # :nodoc: all
      options = [
        ["MechantNo", PAYMENT_CONFIG['pab']['merchantNo']],
        ["OrderNo", self.id],
        ["OrderDate", self.created_at.strftime("%Y-%m-%d")],
        ["PayAmount", format("%.2f", self.payment_price.to_i)],
        ["Currency", 'RMB'],
        ["ReturnURL", "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/pab_return?source=notify"],
        ["TermNo", '05450001'],
        ["JumpURL", "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/pab_return"],
        ["ReservedField", ""],
        ["Version", '2.0'],
      ]
      pab_url(PAYMENT_CONFIG['pab']['gateway'], options)
    end

    def pab_result # :nodoc: all
      options = {
        'MechantNo' => PAYMENT_CONFIG['pab']['merchantNo'],
        'orderNo' => self.id,
      }

      options.merge!('Signature' => Base64.encode64(OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['pab']['private_key']).sign(OpenSSL::Digest::SHA1.new, options.sort.map { |k, v| "#{k}=#{v}" }.join('&'))))
      ret = Timeout::timeout(10) { Mechanize.new.post(URI.parse(PAYMENT_CONFIG['pab']['queryUrl']), options).body }.split("|")[1]
      [['merchantNo', 20], ['orderNo', 30], ['orderAmt', 20], ['tranStat', 1], ['tranTime', 17], ['orderDate', 10], ['payCardType', 1]].map { |k, v| {k => (ret || "").slice!(0..v-1).strip} }.inject(&:merge)
    end

    def pab_pay_result # :nodoc: all
      options = {
        'version' => "1.0.0",
        'charset' => "UTF-8",
        'transType' => "005",
        'merId' => PAYMENT_CONFIG['pab_pay']['merchantId'],
        'mercOrderNo' => self.id
      }
      options.merge!({'signature' => OpenSSL::Digest::SHA256.hexdigest(options.sort.map { |k, v| "#{k}=#{v}" }.join('&')+PAYMENT_CONFIG['pab_pay']['key']), 'signMethod' => 'SHA-256'})
      uri = URI.parse(PAYMENT_CONFIG['pab_pay']['site'])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.ssl_version = 'TLSv1'
      ret = Timeout::timeout(30) { http.post(uri.request_uri, options.map { |k, v| "#{k}=#{v}" }.join('&'), {'Content-Type' => 'application/x-www-form-urlencoded'}).body }
      data = ret.split('&').compact.uniq.map { |value| {value.split('=')[0].to_sym => CGI::unescape(value.split('=')[1])} }.inject(&:merge)
    end

    def pab_pay_checkout_url
      options = {
        'version' => '1.0.0',
        'charset' => 'UTF-8',
        'transType' => '001',
        'transCode' => '0001',
        'merchantId' => PAYMENT_CONFIG['pab_pay']['merchantId'],
        'platMerchantId' => '',
        'backEndUrl' => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/pab_pay_return",
        'frontEndUrl' => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/pab_pay_return",
        'orderTime' => self.created_at.strftime("%Y%m%d%H%M%S"),
        'sameOrderFlag' => '',
        'mercOrderNo' => self.id,
        'merchantTransDesc' => '',
        'language' => '',
        'commodityNo' => '',
        'commodityName' => '',
        'commodityUrl' => '',
        'ommodityUnitPrice' => '',
        'commodityQuantity' => '',
        'commodityDesc' => '',
        'orderAmount' => self.payment_price*100,
        'orderCurrency' => 'CNY',
        'distributeInfo' => '',
        'token' => '',
        'customerMerchantId' => '',
        'customerPAFId' => '',
        'customerName' => '',
        'customerIdType' => '',
        'customerIdNo' => '',
        'specifiedPayType' => '',
        'specifiedBankNumber' => '',
        'transTimeout' => '',
        'antiPhishingTimeStamp' => '',
        'customerIp' => '',
        'customerRefer' => '',
        'mercRetrunPara' => '',
        'businessScene' => '',
        'merReserved' => '',
        'merReserved2' => '',
      }
      pab_pay_url(PAYMENT_CONFIG['pab_pay']['site'], options)
    end

    def pgs_checkout_url # :nodoc: all
      options = {
        "input_charset" => '1',
        "version" => 'v1.0',
        "service_name" => 'payment',
        "language" => '1',
        "bg_url" => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/pgs_return?source=notify",
        "notify_url" => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/pgs_return",
        "sign_type" => '1',
        "partner" => PAYMENT_CONFIG['pgs']['merchantId'],
        "seller_email" => PAYMENT_CONFIG['pgs']['merchantEmail'],
        "seller_mobile" => PAYMENT_CONFIG['pgs']['merchantMobile'],
        "subject" => "#{self.units[0].item.product.name}等#{self.units.count}件",
        "quantity" => self.units.count,
        "detail" => self.identifier,
        "out_trade_no" => self.id,
        "amount" => self.payment_price*100,
        "payment_type" => '03',
        "bank_id" => '',
        "payment_time" => self.created_at.strftime("%Y%m%d%H%M%S"),
        "ext1" => '',
        "ext2" => '',
      }

      pgs_url(PAYMENT_CONFIG['pgs']['gateWay'], options)
    end


    def pab_url(action, options) # :nodoc:
      options << ["Signature", Base64.encode64(OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['pab']['private_key']).sign(OpenSSL::Digest::SHA1.new, options.map { |k, v| "#{k}=#{v}" }.join('&')))]
      cgi_escape_action_and_options(action, options)
    end

    def pab_pay_url(action, options)
      options.merge!('signature' => OpenSSL::Digest::SHA256.hexdigest(options.reject { |k, v| v.blank? }.sort.map { |k, v| "#{k}=#{v}" }.join('&')+PAYMENT_CONFIG['pab_pay']['key']), 'signMethod' => 'SHA-256')
      cgi_escape_action_and_options(action, options)
    end

  end
end
