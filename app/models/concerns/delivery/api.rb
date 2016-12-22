module Delivery
  module Api
    extend ActiveSupport::Concern
    # DELIVERY_SERVICES = [
    #     {:name => 'fedex', :title => '联邦快递', :url => 'https://www.fedex.com/fedextrack/?action=track&cntry_code=cn'},
    #     {:name => 'sf', :title => '顺丰速运', :url => 'http://sf-express.com/cn/sc/'},
    #     {:name => 'zjs', :title => '宅急送', :url => 'http://www.zjs.com.cn/WS_Business/WS_Business_GoodsTrack.aspx'},
    #     {:name => 'ems', :title => '邮政EMS', :url => 'http://www.ems.com.cn/mailtracking/you_jian_cha_xun.html'},
    #     {:name => 'offline', :title => '线下'},
    #     {:name => 'pickup', :title => '自取'},
    # ]
    included do
      # include Delivery::Fedex
      # include Delivery::Sf
      # include Delivery::Zjs
      include Delivery::Kuaidi100
    end

    def trade_delivery_result
      self.class.delivery_result(self.delivery_service, self.delivery_identifier)
    end

    def trade_delivery_result_with_receiving
      result_hash = trade_delivery_result_without_receiving
      self.update_attributes!(:delivery_received_at => result_hash[:received_at]) if result_hash[:received_at] != self.delivery_received_at
      result_hash
    end

    alias_method_chain :trade_delivery_result, :receiving

    def invoice_delivery_result
      self.class.delivery_result(self.invoice_delivery_service, self.invoice_delivery_identifier)
    end

    module ClassMethods
      def delivery_result(express, identifier)
        raise "快递服务不正确" unless valid_express?(express)
        raise "快递编号为空" if identifier.blank?
        send("kuaidi100_data", express, identifier)
      end

      def delivery_result_with_cache(express, identifier)
        Rails.cache.read("delivery_#{express}_#{identifier}") ||
            (Rails.cache.write("delivery_#{express}_#{identifier}", delivery_result = delivery_result_without_cache(express, identifier), :expires_in => delivery_result[:received_at].blank? ? 900 : 604800) && delivery_result)
      end

      alias_method_chain :delivery_result, :cache
    end
  end
end
