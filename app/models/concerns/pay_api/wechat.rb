module PayApi
  module Wechat
    extend ActiveSupport::Concern

    def query_wechat!
      return false unless self.status == 'pay'
      r = begin
        self.wechat_result
      rescue Exception => e
        false
      end
      self.audit!(:payment_service => "wechat") if r && r["errcode"].to_i == 0 && r["order_info"].try(:[], 'ret_code') == 0 && r["order_info"].try(:[], 'out_trade_no').to_i == self.id && r["order_info"].try(:[], 'total_fee').to_i == self.payment_price * 100
    end

    def wechat_assess_token
      token_response = JSON.parse(Timeout::timeout(30) { Mechanize.new.get(PAYMENT_CONFIG['wechat']['tokenUrl'], {grant_type: 'client_credential', appid: PAYMENT_CONFIG['wechat']['appid'], secret: PAYMENT_CONFIG['wechat']['secret']}).body })
      raise '获取微信access_token失败' if token_response["errcode"].present? || token_response["access_token"].blank?
      token_response["access_token"]
    end

    def wechat_result
      package_options = {
        out_trade_no: self.id,
        partner: PAYMENT_CONFIG['wechat']['partnerId'],
      }
      package_options.merge!(sign: Digest::MD5.hexdigest(package_options.sort.map { |k, v| "#{k.to_s}=#{v.to_s}" }.push("key=#{PAYMENT_CONFIG['wechat']['partnerKey']}").join('&')).upcase)
      options = {
        appid: PAYMENT_CONFIG['wechat']['appid'],
        timestamp: Time.now.to_i.to_s,
        package: package_options.map { |k, v| "#{ERB::Util.u(k.to_s)}=#{ERB::Util.u(v.to_s)}" }.join('&'),
      }
      options.merge!(sign_method: 'sha1', app_signature: Digest::SHA1.hexdigest(options.merge(appkey: PAYMENT_CONFIG['wechat']['paySignKey']).sort.map { |k, v| "#{k.to_s}=#{v.to_s}" }.join('&')))

      access_token = self.wechat_assess_token

      pay_response = JSON.parse(Timeout::timeout(30) { Mechanize.new.post("#{PAYMENT_CONFIG['wechat']['queryUrl']}?access_token=#{access_token}", options.to_json).body })

      pay_response
    end


    def wechat_delivernotify
      raise "微信用户open_id为空" unless self.payment_return.present? && (openid = JSON.parse(self.payment_return.to_s).try(:[], 'xml').try(:[], 'OpenId')).present?
      options = {
        appid: PAYMENT_CONFIG['wechat']['appid'],
        openid: openid,
        transid: self.payment_identifier,
        out_trade_no: self.id,
        deliver_timestamp: Time.now.to_i.to_s,
        deliver_status: 1,
        deliver_msg: "ok",
      }
      options.merge!(sign_method: 'sha1', app_signature: Digest::SHA1.hexdigest(options.merge(appkey: PAYMENT_CONFIG['wechat']['paySignKey']).sort.map { |k, v| "#{k.to_s}=#{v.to_s}" }.join('&')))

      access_token = self.wechat_assess_token

      notify_response = JSON.parse(Timeout::timeout(30) { Mechanize.new.post("#{PAYMENT_CONFIG['wechat']['delivernotifyURL']}?access_token=#{access_token}", options.to_json).body })

      notify_response
    end

    def wechat_checkout_url(remote_ip, openid)
      package_options = {
        appid: PAYMENT_CONFIG['wechat']['appid'],
        openid: openid,
        body: "#{self.units[0].item.product.name}等#{self.units.count}件",
        mch_id: PAYMENT_CONFIG['wechat']['partnerId'],
        out_trade_no: self.id,
        total_fee: self.payment_price * 100,
        fee_type: "CNY",
        nonce_str: (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a).sample(32).join,
        trade_type: "JSAPI",
        notify_url: "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/wechat_return",
        spbill_create_ip: remote_ip,
        time_start: self.created_at && self.created_at.strftime("%Y%m%d%H%M%S"),
        time_expire: self.created_at && self.created_at.in(7200).strftime("%Y%m%d%H%M%S")
      }.reject { |k, v| v.blank? }.sort.map { |o| {o.first => o.last} }.inject({}, &:merge)
      package_options.merge!(sign: Digest::MD5.hexdigest(package_options.sort.map { |k, v| "#{k.to_s}=#{v.to_s}" }.push("key=#{PAYMENT_CONFIG['wechat']['paySignKey']}").join('&')).upcase)
      action = "https://api.mch.weixin.qq.com/pay/unifiedorder"
      body="<xml>#{package_options.map { |k, v| "<#{k}>#{v}</#{k}>" }.join}</xml>"
      Rails.logger.info "======#{body}"
      result = Timeout::timeout(30) { HTTParty.post(action, body: body, :headers => {'Content-type' => 'text/xml'}) }
      Rails.logger.info "######{result}"
      result=Nokogiri::XML.parse(CGI::unescape(result))
      if result.search("return_code").first.text=="SUCCESS"
        package_options={
          prepay_id: result.search("prepay_id").first.text
        }
        options = {
          appId: PAYMENT_CONFIG['wechat']['appid'],
          timeStamp: Time.now.to_i.to_s,
          nonceStr: (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a).sample(32).join,
          package: package_options.map { |k, v| "#{ERB::Util.u(k.to_s)}=#{ERB::Util.u(v.to_s)}" }.join('&'),
          signType: 'MD5'
        }
        options.merge!(paySign: Digest::MD5.hexdigest(options.sort.map { |k, v| "#{k.to_s}=#{v.to_s}" }.push("key=#{PAYMENT_CONFIG['wechat']['paySignKey']}").join('&')).upcase)
        Rails.logger.info "=====搜索######{options }"
        options
      else
        raise Exception
      end
    end

    def send_wechat_shipped
      notify_response = self.wechat_delivernotify
      raise '通知微信发货通知接口失败' unless notify_response["errcode"].to_s == '0'
    rescue => e
      logger.error %[#{e.class.to_s}: #{e.message}\n#{e.backtrace.map { |s| "\tfrom #{s}\n" }.join}]
    end

  end
end
