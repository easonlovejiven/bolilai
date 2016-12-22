module Delivery
  module Fedex
    extend ActiveSupport::Concern

    def fedex_query_url # :nodoc: all
      "http://cndxp.apac.fedex.com/service/track/#{self.delivery_identifier}"
    end

    def fedex_result # :nodoc: all
      Mechanize.new.get(self.fedex_query_url).body
    end

    module ClassMethods
      def fedex_result(identifier) # :nodoc: all
        Mechanize.new.get("http://cndxp.apac.fedex.com/service/track/#{identifier}").body
      end


      def fedex_data(identifier) # :nodoc: all
        data = {:orginal => fedex_result(identifier)}
        data[:steps] = Nokogiri::XML(data[:orginal]).xpath("fedex-express/tracking/detail/activities/activity").map { |step| {:time => step.xpath("datetime").text, :address => step.xpath("location").text, :action => step.xpath("scan").text} }.reverse
        data[:received_at] = DateTime.parse(Nokogiri::XML(data[:orginal]).xpath("fedex-express/tracking/detail/deliverydate").text).to_time rescue nil
        data
      end
    end
  end
end
