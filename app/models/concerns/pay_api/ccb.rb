module PayApi
  module Ccb
    def ccb_url(options) # :nodoc:
      action = "https://ibsbjstar.ccb.com.cn/app/ccbMain"
      cgi_escape_action_and_options(action, options)
    end

    def ccb_checkout_url # :nodoc:
      options = [
        ["MERCHANTID", PAYMENT_CONFIG['ccb']['MerchantId']],
        ["POSID", PAYMENT_CONFIG['ccb']['PosId']],
        ["BRANCHID", PAYMENT_CONFIG['ccb']['BranchId']],
        ["ORDERID", self.id],
        ["PAYMENT", self.payment_price],
        ["CURCODE", "01"],
        ["TXCODE", '520100'],
        ["REMARK1", ""],
        ["REMARK2", ""],
      ]
      options += [["MAC", Digest::MD5.hexdigest(options.map { |k, v| "#{k}=#{v}" }.join('&'))]]
      ccb_url(options)
    end

    def ccb_query_data # :nodoc:
      options = [
        ["MERCHANTID", PAYMENT_CONFIG['ccb']['MerchantId']],
        ["BRANCHID", PAYMENT_CONFIG['ccb']['BranchId']],
        ["POSID", PAYMENT_CONFIG['ccb']['PosId']],
        ["ORDERDATE", nil],
        ["BEGORDERTIME", nil],
        ["ENDORDERTIME", nil],
        ["BEGORDERID", self.id],
        ["ENDORDERID", self.id],
        ["QUPWD", PAYMENT_CONFIG['ccb']['QupWd']],
        ["TXCODE", "410405"],
        ["SEL_TYPE", 3],
        ["OPERATOR", nil],
      ]
      options += [['MAC', Digest::MD5.hexdigest(options.map { |k, v| "#{k}=#{k != 'QUPWD' ? v : nil}" }.join('&'))]]
      Crack::XML.parse(Mechanize.new.post("https://ibsbjstar.ccb.com.cn/app/ccbMain", options, {"User-Agent" => "Mozilla/5.0 (X11; U; Linux i686; zh-CN; rv:1.9.1.2) Gecko/20090803 Fedora/3.5.2-2.fc11 Firefox/3.5.2"}).body)
    end

    def self.ccb_verify(signature, data) # :nodoc:
      # rsa = Rjb::import('CCBSign.RSASig').new
      # rsa.setPublicKey(PAYMENT_CONFIG['ccb']['PublicKey'])
      # rsa.verifySigature(signature, data)
      OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['ccb']['PublicKey'].to_a.pack('H*')).verify(OpenSSL::Digest::MD5.new, signature.to_a.pack('H*'), data)
    end


    def query_ccb! # :nodoc: all
      return false unless self.status == 'pay'

      r = begin
        Timeout::timeout(10) do
          self.ccb_query_data
        end
      rescue Exception => e
        false
      end
      self.audit!(:payment_service => "ccb") if r && r['DOCUMENT'] && (o = r['DOCUMENT']['QUERYORDER']) && o['STATUS'] == '成功' && o['AMOUNT'].to_f == self.payment_price
    end

  end
end
