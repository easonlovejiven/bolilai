require 'soap/wsdlDriver'
module Delivery
  module Sf
    extend ActiveSupport::Concern

    def sf_result # :nodoc: all
      options = [
          ["arg0", "<mailnoQuery> <tracking_type>1</tracking_type> <language>1</language> <custid>xxx</custid> <checkword>xxxxxx</checkword> <orders> <order track_number='#{self.delivery_identifier}'/> </orders> </mailnoQuery>"],
      ]
      SOAP::WSDLDriverFactory.new("http://bsp.sf-express.com/bsp-oip/ws/CustomerService?wsdl").create_rpc_driver.logisticQueryStandard(options.map { |k, v| {k => {Fixnum => SOAP::SOAPInt, String => SOAP::SOAPString}[v.class].new(v)} }.inject(&:merge)).__xmlele[0][1].sub("encoding='GB2312'", "encoding='UTF-8'")
    end

    module ClassMethods

      def sf_result(identifier) # :nodoc: all
        options = [
            ["arg0", "<mailnoQuery> <tracking_type>1</tracking_type> <language>1</language> <custid>xxxxx</custid> <checkword>xxxxx</checkword> <orders> <order track_number='#{identifier}'/> </orders> </mailnoQuery>"],
        ]
        SOAP::WSDLDriverFactory.new("http://bsp.sf-express.com/bsp-oip/ws/CustomerService?wsdl").create_rpc_driver.logisticQueryStandard(options.map { |k, v| {k => {Fixnum => SOAP::SOAPInt, String => SOAP::SOAPString}[v.class].new(v)} }.inject(&:merge)).__xmlele[0][1].sub("encoding='GB2312'", "encoding='UTF-8'")
      end

      def sf_data(identifier) # :nodoc: all
        data = {:orginal => sf_result(identifier)}
        data[:steps] = Nokogiri::XML(data[:orginal]).xpath("mailnoResponse/orders/order/steps/step").map { |step| {:time => step.xpath("acceptTime").text, :address => step.xpath("acceptAddress").text, :action => step.xpath("remark").text} }
        data[:received_at] = DateTime.parse(data[:steps].to_a.find { |step| step[:action].match(/已签收/) }[:time]).to_time rescue nil
        data
      end

    end
  end
end
