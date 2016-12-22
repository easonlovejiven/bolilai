module PayApi
  module Bill99
    BILL99_BANKS = [
        {:name => "abc", :title => "中国农业银行", },
        {:name => "bea", :title => "东亚银行", },
        {:name => "bob", :title => "北京银行", },
        {:name => "ccb", :title => "中国建设银行", },
        {:name => "ceb", :title => "中国光大银行", },
        {:name => "cib", :title => "兴业银行", },
        {:name => "cmb", :title => "招商银行", },
        {:name => "gdb", :title => "广东发展银行", },
        {:name => "hxb", :title => "华夏银行", },
        {:name => "sdb", :title => "深圳发展银行", },
        {:name => "bcom", :title => "中国交通银行", },
        {:name => "cbhb", :title => "渤海银行", },
        {:name => "cmbc", :title => "中国民生银行", },
        {:name => "icbc", :title => "中国工商银行", },
        {:name => "nbcb", :title => "宁波银行", },
        {:name => "njcb", :title => "南京银行", },
        {:name => "spdb", :title => "上海浦东发展银行", },
        {:name => "bjrcb", :title => "北京农村商业银行", },
        {:name => "citic", :title => "中信银行", },
        {:name => "post", :title => "中国邮政储蓄", },
        # { :name => "shrcc", :title => "上海农村商业银行", },
        {:name => "boc", :title => "中国银行", },
        # { :name => "gzrcc", :title => "广州市农村信用合作社", },
        {:name => "gzcb", :title => "广州市商业银行", },
        {:name => "hzb", :title => "杭州银行", },
        {:name => "pab", :title => "平安银行", },
        {:name => "hsb", :title => "徽商银行", },
        {:name => "shb", :title => "上海银行", },
        {:name => "czb", :title => "浙江银行", },
        {:name => "srcb", :title => "上海农村商业银行", },
        {:name => "psbc", :title => "中国邮政储蓄银行", },
        {:name => "upop", :title => "银联在线支付", },
    ]

    def query_bill99! # :nodoc: all
      return false unless self.status == 'pay'

      r = begin
        Timeout::timeout(10) do
          options = [
              ['version', 'v2.0'],
              ['signType', 1],
              ['merchantAcctId', PAYMENT_CONFIG['bill99']['merchantAcctId']],
              ['queryType', 0],
              ['queryMode', 1],
              ['orderId', self.id.to_s],

          ]
          options << ['signMsg', Digest::MD5.hexdigest((options+[['key', PAYMENT_CONFIG['bill99']['query_key']]]).map { |k, v| "#{k}=#{v}" }.join('&')).upcase]
          result = SOAP::WSDLDriverFactory.new("https://www.99bill.com/apipay/services/gatewayOrderQuery?wsdl").create_rpc_driver.gatewayOrderQuery(options.map { |k, v| {k => {Fixnum => SOAP::SOAPInt, String => SOAP::SOAPString}[v.class].new(v)} }.inject(&:merge))
          order = result.orders[0]
          signInfo = Digest::MD5.hexdigest((%w[orderId orderAmount orderTime dealTime payResult payType payAmount fee dealId].map { |k| (v = order.send(k)) && v != '' ? [k, v] : nil }.compact+[['key', PAYMENT_CONFIG['bill99']['query_key']]]).map { |k, v| "#{k}=#{v}" }.join('&')).upcase
          signMsg = Digest::MD5.hexdigest((%w[version signType merchantAcctId errCode currentPage pageCount pageSize recordCount].map { |k| (v = result.send(k)) && v != '' ? [k, v] : nil }.compact+[['key', PAYMENT_CONFIG['bill99']['query_key']]]).map { |k, v| "#{k}=#{v}" }.join('&')).upcase
          order.payResult == '10' && order.orderId == self.id.to_s && order.orderAmount.to_s == (self.payment_price*100).to_i.to_s && order.signInfo == signInfo && result.signMsg == signMsg
        end
      rescue Exception => e
        false
      end
      self.audit!(:payment_service => "bill99") if r
    end

    def bill99_result # :nodoc: all
      options = [
          ['version', 'v2.0'],
          ['signType', 1],
          ['merchantAcctId', PAYMENT_CONFIG['bill99']['merchantAcctId']],
          ['queryType', 0],
          ['queryMode', 1],
          ['orderId', self.id.to_s],
      ]
      options << ['signMsg', Digest::MD5.hexdigest((options+[['key', PAYMENT_CONFIG['bill99']['query_key']]]).map { |k, v| "#{k}=#{v}" }.join('&')).upcase]
      result = SOAP::WSDLDriverFactory.new("https://www.99bill.com/apipay/services/gatewayOrderQuery?wsdl").create_rpc_driver.gatewayOrderQuery(options.map { |k, v| {k => {Fixnum => SOAP::SOAPInt, String => SOAP::SOAPString}[v.class].new(v)} }.inject(&:merge))
      result && result.orders && result.orders[0]
    end

    def bill99_checkout_url(bankId = nil) # :nodoc: all
      bill99_url("https://www.99bill.com/gateway/recvMerchantInfoAction.htm", [
                                                                                ["inputCharset", 1],
                                                                                ["pageUrl", "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/bill99_return"],
                                                                                ["bgUrl", "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/bill99_return.xml"],
                                                                                ["version", "v2.0"],
                                                                                ["language", 1],
                                                                                ["signType", 4],
                                                                                ["merchantAcctId", PAYMENT_CONFIG['bill99']['merchantAcctId']],
                                                                                ["orderId", self.id],
                                                                                ["orderAmount", (self.payment_price*100).to_i],
                                                                                ["orderTime", self.created_at.strftime("%Y%m%d%H%M%S")],
                                                                                ["productName", "#{self.units[0].item.product.name}等#{self.units.count}件"],
                                                                                ["productNum", self.units.count],
                                                                                ["productDesc", "#{self.identifier}"],
                                                                                ["payType", bankId ? "10" : "00"],
                                                                                ["bankId", bankId ? bankId.upcase : nil],
                                                                            ])
    end

    def bill99_url(action, options) # :nodoc: all
      options.reject! { |k, v| v.blank? }
      key = OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['bill99']['client_private_key'])
      options << ['signMsg', Base64.encode64(key.sign(OpenSSL::Digest::SHA1.new, options.map { |k, v| "#{k}=#{v}" }.join('&')))]
      cgi_escape_action_and_options(action, options)
    end
  end
end
