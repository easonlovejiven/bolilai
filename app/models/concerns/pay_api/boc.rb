module PayApi
  module Boc
    def query_boc_creditcard! #:nodoc: all
      return false unless self.status == 'pay'
      r = self.boc_creditcard_result
      self.audit!(:payment_service => "boc_creditcard") if r.css('status').text == '0' && r.css('orderid').text.to_i == self.id
    end

    def query_boc! #:nodoc: all
      return false unless self.status == 'pay'
      r = self.boc_result
      self.audit!(:payment_service => "boc") if r.css("body/orderTrans/orderStatus").text == '1' && r.css("body/orderTrans/orderNo").text.to_i == self.id && r.css("body/orderTrans/payAmount").text.to_i == self.payment_price
    end

    def boc_creditcard_url(action, orig) #:nodoc: all
      data = OpenSSL::PKCS7.sign(OpenSSL::X509::Certificate.new(PAYMENT_CONFIG['boc_creditcard']['cert']), OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['boc_creditcard']['private_key']), orig, [], OpenSSL::PKCS7::NOATTR).to_s.sub("-----BEGIN PKCS7-----", '').sub("-----END PKCS7-----", '').delete("\r\n")
      options = {
        'orig' => orig,
        'sign' => data,
        'returnurl' => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/boc_creditcard_return",
        'NOTIFYURL' => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/boc_creditcard_return",
        'transName' => 'paygate'
      }
      logger.info(data)
      cgi_escape_action_and_options(action, options)
    end

    def boc_url(action, options)
      data = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(PAYMENT_CONFIG['boc']['cert']), OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['boc']['private_key']), ["orderNo", "orderTime", "curCode", "orderAmount", "merchantNo"].map { |field| options[field] }.join("|"), [], OpenSSL::PKCS7::NOATTR).to_s.sub("-----BEGIN PKCS7-----", '').sub("-----END PKCS7-----", '').delete("\r\n")
      logger.info(data)
      cgi_escape_action_and_options(action, options.merge("signData" => data))
    end
    def boc_creditcard_result #:nodoc: all
      options = {
        'serialno' => PAYMENT_CONFIG['boc_creditcard']['serialNo'],
        'masterid' => PAYMENT_CONFIG['boc_creditcard']['masterId'],
        'orderid' => self.id,
        'terminalID' => PAYMENT_CONFIG['boc_creditcard']['terminalID'],
        'remark' => '',
      }

      sign = OpenSSL::PKCS7.sign(OpenSSL::X509::Certificate.new(PAYMENT_CONFIG['boc_creditcard']['cert']), OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['boc_creditcard']['private_key']), "#{options['serialno']}|#{options['masterid']}|#{options['orderid']}|null|null|null|null|null|null|null|#{options['terminalID']}|null|", [], OpenSSL::PKCS7::NOATTR).to_s.sub("-----BEGIN PKCS7-----", '').sub("-----END PKCS7-----", '').delete("\r\n")

      m = Mechanize.new
      m.cert= OpenSSL::X509::Certificate.new(PAYMENT_CONFIG['boc_creditcard']['cert'])
      m.key = OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['boc_creditcard']['private_key'])
      m.verify_mode= OpenSSL::SSL::VERIFY_NONE
      result = Timeout::timeout(10) { m.put(URI.parse(PAYMENT_CONFIG['boc_creditcard']['queryUrl']), "<orderCheck><orig><serialno>#{options['serialno']}</serialno><masterid>#{options['masterid']}</masterid><orderid>#{options['orderid']}</orderid><terminalID>#{options['terminalID']}</terminalID><remark>#{options['remark']}</remark></orig><sign>#{sign}</sign></orderCheck>").body }
      Nokogiri::XML::Document.parse(result).css("result").first
    end

    def boc_result #:nodoc: all
      options = {
        'merchantNo' => PAYMENT_CONFIG['boc']['merchantNo'],
        'orderNos' => self.id,
      }
      options.merge!('signData' => OpenSSL::PKCS7.sign(OpenSSL::X509::Certificate.new(PAYMENT_CONFIG['boc']['cert']), OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['boc']['private_key']), "#{options['merchantNo']}:#{options['orderNos']}", [], OpenSSL::PKCS7::NOATTR).to_s.sub("-----BEGIN PKCS7-----", '').sub("-----END PKCS7-----", '').delete("\r\n"))
      m = Mechanize.new
      m.cert= OpenSSL::X509::Certificate.new(PAYMENT_CONFIG['boc']['cert'])
      m.key = OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['boc']['private_key'])
      m.verify_mode= OpenSSL::SSL::VERIFY_NONE
      result = Timeout::timeout(10) { m.post(URI.parse(PAYMENT_CONFIG['boc']['queryUrl']), options).body }
      Nokogiri::XML::Document.parse(result).css("res").first
    end

    def boc_creditcard_checkout_url(remote_ip) #:nodoc: all
      orig_hash = {
        'serialno' => self.created_at.strftime("%Y%m%d%H%M%S") + "%04d" % rand(10000),
        'masterid' => PAYMENT_CONFIG['boc_creditcard']['masterId'],
        'orderid' => self.id,
        'currency' => '165',
        'amount' => self.payment_price.to_i*100,
        'isInstalment' => 1,
        'instalmentNum' => 12,
        'instalmentPlan' => 'IP04',
        'date' => self.created_at.strftime("%Y%m%d"),
        'timestamp' => self.created_at.strftime("%H%M%S"),
        'terminalID' => PAYMENT_CONFIG['boc_creditcard']['terminalID'],
        'remark' => '',
        'orderpaytype' => "",
        'referer' => "",
        'cstIP' => '',
      }

      boc_creditcard_url(PAYMENT_CONFIG['boc_creditcard']['gateway'], orig_hash.map { |k, v| "#{k}=#{v}" }.join("|"))
    end

    def boc_checkout_url # :nodoc:
      options = {
        "merchantNo" => PAYMENT_CONFIG['boc']['merchantNo'],
        "payType" => '1',
        "orderNo" => self.id,
        "curCode" => '001',
        "orderAmount" => format("%.2f", self.payment_price.to_i),
        "orderTime" => self.created_at.strftime("%Y%m%d%H%M%S"),
        "orderNote" => "#{self.units[0].item.product.name}等#{self.units.count}件",
        "orderUrl" => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/boc_return",
      }

      boc_url(PAYMENT_CONFIG['boc']['gateway'], options)
    end
  end
end
