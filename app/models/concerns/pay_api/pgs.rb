module PayApi
  module Pgs

    def query_pgs! # :nodoc: all
      return false unless self.status == 'pay'
      r = self.pgs_result
      self.audit!(:payment_service => "pgs") if r && r['trade_status'] == '00' && r['ext1'].to_i == self.payment_price*100
    end
    def pgs_result # :nodoc: all
      options = {
        'input_charset' => '1',
        'version' => 'v1.0',
        'service_name' => 'query_status',
        'language' => '1',
        'sign_type' => '1',
        'partner' => PAYMENT_CONFIG['pgs']['merchantId'],
        'out_trade_no' => self.id,
        'ext1' => self.payment_price*100,
        'ext2' => self.identifier,
      }

      options.merge!('sign' => Digest::MD5.hexdigest("#{options.sort.map { |k, v| "#{k.to_s}=#{v.to_s}" }.join('&')}"+PAYMENT_CONFIG['pgs']['signNo']))
      data = {}
      Timeout::timeout(10) { Mechanize.new.get(URI.parse(PAYMENT_CONFIG['pgs']['queryUrl']), options).body }.split("&amp;").each { |r| data[r.split('=')[0]] = r.to_s.split('=')[1] ||= "" }
      data
    end

    def pgs_url(action, options) # :nodoc:
      options.merge!('sign' => Digest::MD5.hexdigest("#{options.sort.map { |k, v| "#{k.to_s}=#{v.to_s}" }.join('&')}"+PAYMENT_CONFIG['pgs']['signNo']))
      cgi_escape_action_and_options(action, options)
    end

  end
end
