module PayApi
  module Icbc
    def icbc_result
      data = %[
			<?xml  version="1.0" encoding="GBK" standalone="no" ?>
			<ICBCAPI>
				<in>
					<orderNum>#{self.id}</orderNum>
					<tranDate>#{self.created_at.strftime("%Y%m%d%H%M%S")}</tranDate>
					<ShopCode>#{PAYMENT_CONFIG['icbc']['merID']}</ShopCode>
					<ShopAccount>#{PAYMENT_CONFIG['icbc']['merAcct']}</ShopAccount>
				</in>
			</ICBCAPI>
		]
      options = {
        'APIName' => 'EAPI',
        'APIVersion' => '001.001.002.001',
        'MerReqData' => data.delete("\n\t"),
      }

      m = Mechanize.new
      m.cert= OpenSSL::X509::Certificate.new(PAYMENT_CONFIG['icbc']['public_key'])
      m.key = OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['icbc']['private_key'])
      m.verify_mode= OpenSSL::SSL::VERIFY_NONE
      ret = Timeout::timeout(5) { m.post(URI.parse(PAYMENT_CONFIG['icbc']['queryUrl']), options).body }
      URI.unescape(ret).encode('UTF-8', 'GBK')
    end

    def icbc_checkout_url # :nodoc:
      options = {
        "interfaceName" => 'ICBC_PERBANK_B2C',
        "interfaceVersion" => '1.0.0.14',
        "merSignMsg" => '',
        "merCert" => '',
      }
      tranData = %[
			<?xml version="1.0" encoding="GBK" standalone="no"?>
			<B2CReq>
				<interfaceName>#{options["interfaceName"]}</interfaceName>
				<interfaceVersion>#{options["interfaceVersion"]}</interfaceVersion>
				<orderInfo>
					<orderDate>#{self.created_at.strftime("%Y%m%d%H%M%S")}</orderDate>
					<curType>001</curType>
					<merID>#{PAYMENT_CONFIG['icbc']['merID']}</merID>
					<subOrderInfoList>
						<subOrderInfo>
							<orderid>#{self.id}</orderid>
							<amount>#{self.price*100}</amount>
							<installmentTimes>1</installmentTimes>
							<merAcct>#{PAYMENT_CONFIG['icbc']['merAcct']}</merAcct>
							<goodsID></goodsID>
							<goodsName>#{self.units[0].item.product.name}等</goodsName>
							<goodsNum>#{self.units.count}</goodsNum>
							<carriageAmt></carriageAmt>
						</subOrderInfo>
					</subOrderInfoList>
				</orderInfo>
				<custom>
					<verifyJoinFlag>0</verifyJoinFlag>
					<Language>ZH_CN</Language>
					<HangSupportFlag>1</HangSupportFlag>
					<HangTimeInterval>2</HangTimeInterval>
				</custom>
				<message>
					<creditType>2</creditType>
					<notifyType>HS</notifyType>
					<resultType>0</resultType>
					<merReference>*.weimall.com</merReference>
					<merCustomIp></merCustomIp>
					<goodsType>1</goodsType>
					<merCustomID>123456</merCustomID>
					<merCustomPhone>13466780886</merCustomPhone>
					<goodsAddress>朝阳</goodsAddress>
					<merOrderRemark>奢侈品</merOrderRemark>
					<merHint>weimall</merHint>
					<remark1></remark1>
					<remark2></remark2>
					<merURL>http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/icbc_return</merURL>
					<merVAR></merVAR>
				</message>
			</B2CReq>
		]
      data = tranData.delete("\n\t").encode("GBK", "UTF-8")
      sign = OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['icbc']['private_key']).private_encrypt(Digest::SHA1.digest(data))
      logger.info(data)
      options.merge!({
                       'tranData' => Base64.encode64(data).delete("\n\t"),
                       'merSignMsg' => Base64.encode64(sign).encode("UTF-8", "ISO-8859-1").delete("\n\t"),
                       'merCert' => PAYMENT_CONFIG['icbc']['public_key'].sub("-----BEGIN CERTIFICATE-----", '').sub("-----END CERTIFICATE-----", '').delete("\n\t")
                     })
      icbc_url(PAYMENT_CONFIG['icbc']['gateway'], options)
    end

    def query_icbc!
      return false unless self.status == 'pay'
      r = Nokogiri::XML(self.icbc_result)
      self.audit!(payment_service: "icbc") if r && r.xpath('ICBCAPI/out/tranStat').text == '1' && r.xpath('ICBCAPI/out/amount').text.to_i == self.price*100
    end
    private

    def icbc_url(action, options)
      cgi_escape_action_and_options(action, options)
    end
  end
end
