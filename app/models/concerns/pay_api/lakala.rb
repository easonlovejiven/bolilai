module PayApi
  module Lakala

    def query_lakala! # :nodoc: all
      return false unless self.status == 'pay'

      data = self.lakala_result rescue {}
      self.audit!(:payment_service => 'lakala', :payment_identifier => data[:pay_seq]) if data[:result] == 'Y' && data[:amount].to_i == self.payment_price
    end

    def lakala_result # :nodoc: all
      options = {
        :ver_id => '20060301',
        :mer_id => PAYMENT_CONFIG['lakala']['mer_id'],
        :order_id => self.id,
        :order_date => self.created_at.strftime("%Y%m%d"),
        :mac_type => 2,
        :ret_mode => 1,
      }
      options.merge!(:verify_string => Digest::MD5.hexdigest(%w[ver_id mer_id order_date order_id mac_type mer_key].map { |f| "#{f}=#{options.merge(:mer_key => PAYMENT_CONFIG['lakala']['password'])[f.to_sym]}" }.join('&')))
      ret = Timeout::timeout(10) { HTTParty.get("http://pgs.paygate.cn:8888/tradeSearch/ndsinglesearch", :query => options).body }
      data = "account_date|amount|pay_method|mer_id|order_date|order_id|pay_seq|result|ver_id|verify_string".split('|').map(&:to_sym).each_with_index.map { |key, i| {key => ret.split('|')[i]} }.inject(&:merge)
      raise 'incorrect signature' unless data[:verify_string] == Digest::MD5.hexdigest(%w[ver_id mer_id order_date order_id amount result mer_key].map { |f| "#{f}=#{data.merge(:mer_key => PAYMENT_CONFIG['lakala']['password'])[f.to_sym]}" }.join('&'))
      data
    end


    def lakala_checkout_url # :nodoc: all
      action = "#{PAYMENT_CONFIG['lakala']['site']}"
      options = {
        :billNo => "#{PAYMENT_CONFIG['lakala']['bill_no_prefix']}#{self.id}",
        :amount => self.payment_price,
        :merID => PAYMENT_CONFIG['lakala']['mer_id'],
      }
      options.merge!(:verCode => Digest::MD5.hexdigest([options[:merID], options[:billNo], PAYMENT_CONFIG['lakala']['password']].join))
      cgi_escape_action_and_options(action, options)
    end
  end
end
