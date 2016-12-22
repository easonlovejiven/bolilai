module PayApi
  module Cmbc
    def cmbc_checkout_url # :nodoc: all
      options = [
        ["billNo", PAYMENT_CONFIG['cmbc']['merchantId']+self.id.to_s.rjust(15, '0')],
        ["txAmt", self.payment_price],
        ["PayerCurr", '01'],
        ["txDate", self.created_at.strftime("%Y%m%d")],
        ["txTime", self.created_at.strftime("%H%M%S")],
        ["corpID", PAYMENT_CONFIG['cmbc']['merchantId']],
        ["corpName", PAYMENT_CONFIG['cmbc']['corpName']],
        ["Billremark1", ""],
        ["Billremark2", ""],
        ["CorpRetType", "0"],
        ["retUrl", "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/cmbc_return"],
        ["MAC", ""]
      ]

      cmbc_url(PAYMENT_CONFIG['cmbc']['gateway'], options.map { |k, v| v }.join('|').encode('gbk', 'utf-8'))
    end

    def query_cmbc! # :nodoc: all
      return false unless self.status == 'pay'
      r = self.cmbc_result
      self.audit!(:payment_service => "cmbc") if r && r[:status] == '1' && r[:order_price].to_f == self.payment_price
    end

    def cmbc_result # :nodoc: all
      options = [
        ["corpID", PAYMENT_CONFIG['cmbc']['merchantId']],
        ["billNo", PAYMENT_CONFIG['cmbc']['merchantId']+self.id.to_s.rjust(15, '0')],
      ]

      envelop_data = CMBC::JnkyServer.envelop_data(PAYMENT_CONFIG['cmbc']['public_key'], PAYMENT_CONFIG['cmbc']['private_key'], PAYMENT_CONFIG['cmbc']['cert'], PAYMENT_CONFIG['cmbc']['key'], options.map { |k, v| v }.join("|"))
      result = Timeout::timeout(10) { HTTParty.get("#{PAYMENT_CONFIG['cmbc']['queryUrl']}?cryptograph=#{CGI::escape(envelop_data)}").body.delete("\n").split.join('').gsub(/<(\/|)html>|<(\/|)body>|<(\/|)div>/, "") }

      decrypt_data = CMBC::JnkyServer.decrypt_data(PAYMENT_CONFIG['cmbc']['public_key'], PAYMENT_CONFIG['cmbc']['private_key'], URI.unescape(result))

      "order_id|order_price|status|desc".split('|').map(&:to_sym).each_with_index.map { |key, i| {key => decrypt_data.encode('utf-8', 'gbk').split('|')[i]} }.inject(&:merge)
    end
    private

    def cmbc_url(action, str) # :nodoc:
      envelop_data = CMBC::JnkyServer.envelop_data(PAYMENT_CONFIG['cmbc']['public_key'], PAYMENT_CONFIG['cmbc']['private_key'], PAYMENT_CONFIG['cmbc']['cert'], PAYMENT_CONFIG['cmbc']['key'], str)
      logger.info(envelop_data)
      cgi_escape_action_and_options(action, {"orderinfo" => envelop_data})
    end
  end
end
