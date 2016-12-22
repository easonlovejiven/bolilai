module PayApi
  module Comm


    def query_comm_creditcard! #:nodoc: all
      return false unless self.status == 'pay'
      r = self.comm_creditcard_result
      self.audit!(:payment_service => "comm_creditcard") if r.css('returnCode').text == '00' && r.attr('id').to_i == self.id && r.css('totalAmount').text.to_i == self.payment_price
    end

    def comm_creditcard_checkout_url
      self.payment_identifier = self.created_at.strftime("%Y%m%d%H%M%S") + '%04d' % (!self.payment_identifier.blank? && (self.payment_identifier.last(4).to_i + 1) || 0)
      self.save
      str = %Q[
		<?xml version="1.0" encoding="utf-8" ?>
		<shopOrderService version="1.0" xmlns="http://creditcard.bankcomm.com/shopOrderService">
			<orderData id="#{self.id}" shopTraceNo="#{self.payment_identifier}">
				<submitTime>#{self.created_at.strftime("%Y%m%d%H%M%S")}</submitTime>
				<description></description>
				<merchant id="#{PAYMENT_CONFIG['comm_creditcard']['merchantId']}" name="交行信用卡中心网上商城" />
				<notification mode="2">
					<autoJumpResult time="5">
						<resultUrl>http://comm.weimall.com/shop/trades/#{self.id}/comm_creditcard_return?orderId=#{self.id}</resultUrl>
					</autoJumpResult>
				</notification>
				<transData type="020110">
					<totalAmount currency="156">#{self.payment_price*100}</totalAmount>
				</transData>
			</orderData>
		</shopOrderService>
		]
      data = COMM::SecurityMessageCrypto.MakeSecurityMessage(str.delete("\n\t"), "#{RAILS_ROOT}/config/comm.cer", "#{RAILS_ROOT}/config/comm.pfx", PAYMENT_CONFIG['comm_creditcard']['password'], PAYMENT_CONFIG['comm_creditcard']['merchantId'])
      "#{PAYMENT_CONFIG['comm_creditcard']['gateway']}?transDataXml=#{data}"
    end


    def comm_creditcard_result #:nodoc: all
      str = %Q[
		<?xml version="1.0" encoding="utf-8" ?>
		<shopOrderService version="1.0" xmlns="http://creditcard.bankcomm.com/shopOrderService">
			<orderData id="#{self.id}" shopTraceNo="#{self.payment_identifier}">
				<submitTime>#{self.created_at.strftime("%Y%m%d%H%M%S")}</submitTime>
				<merchant id="#{PAYMENT_CONFIG['comm_creditcard']['merchantId']}" name="交行信用卡中心网上商城" />
				<transData type="030130">
					<totalAmount currency="156">#{self.payment_price.to_i}</totalAmount>
					<oldSubmitTime>#{self.created_at.strftime("%Y%m%d%H%M%S")}</oldSubmitTime>
					<oldTransType>020110</oldTransType>
				</transData>
			</orderData>
		</shopOrderService>
		]

      data = COMM::SecurityMessageCrypto.MakeSecurityMessage(str.delete("\n\t"), "#{RAILS_ROOT}/config/comm.cer", "#{RAILS_ROOT}/config/comm.pfx", PAYMENT_CONFIG['comm_creditcard']['password'], PAYMENT_CONFIG['comm_creditcard']['merchantId'])
      return_body = Mechanize.new.post(PAYMENT_CONFIG['comm_creditcard']['queryUrl'], {:transDataXml => data}).body
      xml = COMM::SecurityMessageCrypto.OpenSecurityMessage(return_body, "#{RAILS_ROOT}/config/comm.cer", "#{RAILS_ROOT}/config/comm.pfx", PAYMENT_CONFIG['comm_creditcard']['password'])
      Nokogiri::XML::Document.parse(xml).css("shopOrderService/orderData").first
    end
  end
end
