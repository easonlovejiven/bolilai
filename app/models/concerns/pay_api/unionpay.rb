module PayApi
  module Unionpay
    def query_unionpay! # :nodoc: all
      return false unless self.status == 'pay'

      data = self.unionpay_result
      self.audit!(:payment_service => 'unionpay', :payment_identifier => data[:qid]) if data[:queryResult] == '0' && data[:settleAmount].to_i == self.payment_price*100
    end

    def query_unionpay_wap!
      return false unless self.status == 'pay'
      data = self.unionpay_wap_result
      self.audit!(:payment_service => 'unionpay_wap', :payment_identifier => data[:qn]) if data[:respCode] == '00' && data[:transStatus] == '00' && data[:settleAmount].to_i == self.payment_price*100
    end

    def unionpay_wap_result
      options = {
        'version' => '1.0.0',
        'charset' => 'UTF-8',
        'transType' => '01',
        'merId' => PAYMENT_CONFIG['unionpay_wap']['merId'],
        'orderTime' => self.created_at.strftime("%Y%m%d%H%M%S"),
        'orderNumber' => "%08d" % self.id,
      }
      options.merge!({
                       'signMethod' => 'MD5',
                       'signature' => Digest::MD5.hexdigest("#{options.sort.map { |k, v| "#{k}=#{v}" }.join("&")}&"+Digest::MD5.hexdigest(PAYMENT_CONFIG['unionpay_wap']['securityKey'])),
                     })
      uri = URI.parse(PAYMENT_CONFIG['unionpay_wap']['queryUrl'])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.ssl_version = 'TLSv1'
      ret = Timeout::timeout(10) { http.post(uri.request_uri, options.map { |k, v| "#{k}=#{v}" }.join('&'), {'Content-Type' => 'application/x-www-form-urlencoded'}).body }
      data = ret.split('&').compact.uniq.map { |value| {value.split('=')[0].to_sym => CGI::unescape(value.split('=')[1])} }.inject(&:merge)
      raise 'incorrect signature' unless data[:signature] == Digest::MD5.hexdigest("#{data.except(:signMethod, :signature).sort.map { |k, v| "#{k}=#{v}" }.join('&')}&"+Digest::MD5.hexdigest(PAYMENT_CONFIG['unionpay_wap']['securityKey']))
      data
    end


    def unionpay_checkout_url(remote_ip) # :nodoc:
      options = {
        'version' => '1.0.0',
        'charset' => 'UTF-8',
        'transType' => '01',
        'merAbbr' => PAYMENT_CONFIG['unionpay']['merAbbr'],
        'merId' => PAYMENT_CONFIG['unionpay']['merId'],
        'backEndUrl' => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/unionpay_return?source=notify",
        'frontEndUrl' => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/unionpay_return",
        'orderTime' => self.created_at.strftime("%Y%m%d%H%M%S"),
        'orderNumber' => "%08d" % self.id,
        'orderAmount' => (self.payment_price*100).to_s,
        'orderCurrency' => '156',
        'transTimeout' => '7200000',
        'customerIp' => remote_ip,
        'acqCode' => '',
        'commodityDiscount' => '',
        'commodityName' => '',
        'commodityQuantity' => '',
        'commodityUnitPrice' => '',
        'commodityUrl' => '',
        'customerName' => '',
        'defaultBankNumber' => '',
        'defaultPayType' => '',
        'merCode' => '',
        'merReserved' => '',
        'origQid' => '',
        'transferFee' => '',
      }
      unionpay_url(PAYMENT_CONFIG['unionpay']['gateWay'], options);
    end

    def unionpay_result # :nodoc: all
      options = {
        'version' => "1.0.0",
        'charset' => "UTF-8", #
        'transType' => '01',
        'merId' => PAYMENT_CONFIG['unionpay']['merId'], #
        'orderNumber' => "%08d" % self.id,
        'orderTime' => self.created_at.strftime("%Y%m%d%H%M%S"),
        'merReserved' => '',
      }
      options.merge!({
                       'signature' => Digest::MD5.hexdigest("#{options.sort.map { |k, v| "#{k.to_s}=#{v.to_s}" }.join('&')}&"+Digest::MD5.hexdigest(PAYMENT_CONFIG['unionpay']['securityKey'])),
                       'signMethod' => 'MD5',
                     })
      ret = Timeout::timeout(10) { Mechanize.new.post(URI.parse(PAYMENT_CONFIG['unionpay']['queryUrl']), options).body }
      data = ret.gsub(/cupReserved=\{([^}]*)\}/, '\1').split('&').compact.uniq.map { |value| {value.split('=')[0].to_sym => value.split('=')[1]} }.inject(&:merge)
      raise 'incorrect signature' unless data[:signature] == Digest::MD5.hexdigest("#{ret.gsub(/&signMethod=[^&]*|&signature=[^&]*/, '')}&"+Digest::MD5.hexdigest(PAYMENT_CONFIG['unionpay']['securityKey']))
      data.slice(:queryResult, :settleAmount, :qid)
    end


    def unionpay_wap_checkout_url
      options = {
        'version' => '1.0.0',
        'charset' => 'UTF-8',
        'transType' => '01',
        'merId' => PAYMENT_CONFIG['unionpay_wap']['merId'],
        'backEndUrl' => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/unionpay_wap_return",
        'frontEndUrl' => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/unionpay_wap_return",
        'orderTime' => self.created_at.strftime("%Y%m%d%H%M%S"),
        'orderNumber' => "%08d" % self.id,
        'orderAmount' => (self.payment_price*100).to_s,
        'orderCurrency' => '156',
      }

      unionpay_wap_url(options)
    end

    def unionpay_wap_url(options)
      options.merge!({
                       'signMethod' => 'MD5',
                       'signature' => Digest::MD5.hexdigest("#{options.sort.map { |k, v| "#{k}=#{v}" }.join("&")}&"+ Digest::MD5.hexdigest(PAYMENT_CONFIG['unionpay_wap']['securityKey']))
                     })
      uri = URI.parse(PAYMENT_CONFIG['unionpay_wap']['gateWay'])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.ssl_version = 'TLSv1'
      body = options.sort.map { |k, v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" }.join('&')
      result = Timeout::timeout(10) { http.post(uri.request_uri, body, {'Content-Type' => 'application/x-www-form-urlencoded'}).body }
      logger.info(result)
      tmp_hash = Hash[*result.split('&').map { |x| x.split('=') }.flatten]
      raise 'incorrect signature' unless tmp_hash['respCode'] == '00' && tmp_hash['signature'] == Digest::MD5.hexdigest("#{tmp_hash.except('signMethod', 'signature').sort.map { |k, v| "#{k}=#{CGI::unescape(v.to_s)}" }.join("&")}&"+ Digest::MD5.hexdigest(PAYMENT_CONFIG['unionpay_wap']['securityKey']))
      tmp_hash['tn']
    end

    private
    def unionpay_url(action, options) # :nodoc:
      options.merge!({
                       'signature' => Digest::MD5.hexdigest("#{options.sort.map { |k, v| "#{k.to_s}=#{v.to_s}" }.join('&')}&"+Digest::MD5.hexdigest(PAYMENT_CONFIG['unionpay']['securityKey'])),
                       'signMethod' => 'MD5',
                     })
      cgi_escape_action_and_options(action, options)
    end
  end
end
