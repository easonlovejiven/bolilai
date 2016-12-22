module PayApi
  module Cmbchina
    def query_cmbchina! # :nodoc: all
      return false unless self.status == 'pay'

      r = begin
        Timeout::timeout(10) do
          settle = CMBCHINA::Settle.new
          settle.SetOptions("payment.ebank.cmbchina.com")
          status = settle.LoginC(PAYMENT_CONFIG['cmbchina']['BranchID'], PAYMENT_CONFIG['cmbchina']['CoNo']+PAYMENT_CONFIG['cmbchina']['OperatorCode'], PAYMENT_CONFIG['cmbchina']['Password'])
          Rails.logger.info "cmbchina_query_login #{status}"
          return false unless status.zero?

          sb = CMBCHINA::StringBuffer.new
          status = settle.QuerySingleOrder(self.created_at.strftime("%Y%m%d"), self.id.to_s.rjust(10, '0'), sb)
          Rails.logger.info "cmbchina_query_order #{status}"
          status.zero? && format("%.2f", self.payment_price.to_f) == sb.toString.split("\n")[-1]
        end
      rescue Exception => e
        false
      end
      self.audit!(:payment_service => 'cmbchina') if r
    end


    def query_cmbchina_creditcard!
      return false unless self.status == 'pay'
      r = begin
        Timeout::timeout(10) do
          self.cmbchina_creditcard_result
        end
      rescue Exception => e
        false
      end
      self.audit!(:payment_service => "cmbchina_creditcard") if r && r.css('MchBllNbr').text.to_i == self.id && r.css("BllStlAmt").text.to_i == self.payment_price
    end

    def cmbchina_result # :nodoc: all
      settle = CMBCHINA::Settle.new
      settle.SetOptions("payment.ebank.cmbchina.com")
      status = settle.LoginC(PAYMENT_CONFIG['cmbchina']['BranchID'], PAYMENT_CONFIG['cmbchina']['CoNo']+PAYMENT_CONFIG['cmbchina']['OperatorCode'], PAYMENT_CONFIG['cmbchina']['Password'])
      Rails.logger.info "cmbchina_query_login #{status}"
      return false unless status.zero?

      sb = CMBCHINA::StringBuffer.new
      status = settle.QuerySingleOrder(self.created_at.strftime("%Y%m%d"), self.id.to_s.rjust(10, '0'), sb)
      Rails.logger.info "cmbchina_query_order #{status}"

      result = {:status => status, :desc => settle.GetLastErr(status), :payment => sb.toString.split("\n")[-1]}
    end

    def cmbchina_creditcard_result # :nodoc: all
      login = Mechanize.new.post(PAYMENT_CONFIG['cmbchina_creditcard']['queryUrl'], :Request => "<$Request$><$Head$><$Command$>Login</$Command$></$Head$><$Body$><$Cono$>#{PAYMENT_CONFIG['cmbchina_creditcard']['CoNo']}</$Cono$><$OperatorID$>#{PAYMENT_CONFIG['cmbchina_creditcard']['OperatorID']}</$OperatorID$><$Password$>#{PAYMENT_CONFIG['cmbchina_creditcard']['Password']}</$Password$></$Body$></$Request$>").body
      connection = Nokogiri::XML::Document.parse(login.delete('$')).css('Connection').text
      result = Mechanize.new.post(PAYMENT_CONFIG['cmbchina_creditcard']['queryUrl'], :Request => "<$Request$><$Head$><$Command$>QuerySingleOrder</$Command$><$Connection$>#{connection}</$Connection$></$Head$><$Body$><$MchBllNbr$>#{"%010d" % self.id}</$MchBllNbr$><$MchBllDat$>#{self.created_at.strftime("%Y%m%d")}</$MchBllDat$></$Body$></$Request$>").body.delete("$")
      Mechanize.new.post(PAYMENT_CONFIG['cmbchina_creditcard']['queryUrl'], :Request => "<$Request$><$Head$><$Command$>Logout</$Command$><$Connection$>#{connection}</$Connection$></$Head$></$Request$>")
      Nokogiri::XML(result.delete("$"))
    end

    def cmbchina_checkout_url(params = {}) # :nodoc: all
      action = "https://netpay.cmbchina.com/netpayment/BaseHttp.dll"
      options = {
        "BranchID" => PAYMENT_CONFIG['cmbchina']['BranchID'],
        "CoNo" => PAYMENT_CONFIG['cmbchina']['CoNo'],
        "BillNo" => self.id.to_s.rjust(10, '0'),
        "Amount" => format("%.2f", self.payment_price.to_f),
        "Date" => self.created_at.strftime("%Y%m%d"),
        "MerchantUrl" => "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/cmbchina_return?#{"redirect=#{CGI.escape(params[:redirect])}" if params[:redirect]}",
        "MerchantPara" => "identifier=#{self.identifier}",
      }
      "#{action}?#{params[:type] == 'wap' ? "MfcISAPICommand=PrePayWAP" : "PrePayC2"}&#{options.sort.map { |k, v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" }.join('&')}"
    end

    def cmbchina_creditcard_checkout_url(installment)
      str = %Q[
			<$Head$>
				<$Version$>1.0.0.0</$Version$>
				<$TestFlag$>N</$TestFlag$>
			</$Head$>
			<$Body$>
				<$MchMchNbr$>#{PAYMENT_CONFIG['cmbchina_creditcard']['CoNo']}</$MchMchNbr$>
				<$MchBllNbr$>#{self.id.to_s.rjust(10, '0')}</$MchBllNbr$>
				<$MchBllDat$>#{self.created_at.strftime("%Y%m%d")}</$MchBllDat$>
				<$MchBllTim$>#{self.created_at.strftime("%H%M%S")}</$MchBllTim$>
				<$TrxTrxCcy$>156</$TrxTrxCcy$>
				<$TrxBllAmt$>#{self.payment_price}</$TrxBllAmt$>
				<$TrxPedCnt$>#{installment.blank? ? 12 : installment}</$TrxPedCnt$>
				<$UIHidePed$>Y</$UIHidePed$>
				<$MchUsrIdn$>11111</$MchUsrIdn$>
				<$MchNtfUrl$>http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/cmbchina_creditcard_return</$MchNtfUrl$>
				<$MchNtfPam$>Success</$MchNtfPam$>
				<$TrxGdsGrp$>111111</$TrxGdsGrp$>
				<$TrxGdsNam$>weimall</$TrxGdsNam$>
				<$TrxPstAdr$>beijing</$TrxPstAdr$>
				<$TrxPstTel$>11111111111</$TrxPstTel$>
			</$Body$>].delete("\n\t")
      "#{PAYMENT_CONFIG['cmbchina_creditcard']['gateWay']}&<$CDPRequest_Pay$>#{str}<$Signature$>#{Digest::SHA1.hexdigest(PAYMENT_CONFIG['cmbchina_creditcard']['key']+str).downcase}</$Signature$></$CDPRequest_Pay$>"
    end


    private

    def cmbc_url(action, str) # :nodoc:
      envelop_data = CMBC::JnkyServer.envelop_data(PAYMENT_CONFIG['cmbc']['public_key'], PAYMENT_CONFIG['cmbc']['private_key'], PAYMENT_CONFIG['cmbc']['cert'], PAYMENT_CONFIG['cmbc']['key'], str)
      logger.info(envelop_data)
      cgi_escape_action_and_options(action, {"orderinfo" => envelop_data})
    end
  end
end
