module Delivery
  module Zjs
    extend ActiveSupport::Concern

    def zjs_result # :nodoc: all
      drv = SOAP::WSDLDriverFactory.new("http://edi.zjs.com.cn/service/query.asmx?wsdl").create_rpc_driver
      options = [
        ["strInfo", "<BatchQueryRequest> <logisticProviderID>xxxxx</logisticProviderID> <orders> <order> <orderNo>#{self.delivery_identifier}</orderNo> </order> </orders> </BatchQueryRequest>"],
        ["userId", "xxxx"]
      ]
      options << ["md5", drv.GetMd5(options.map { |k, v| {k => {Fixnum => SOAP::SOAPInt, String => SOAP::SOAPString}[v.class].new(v)} }.inject(&:merge)).__xmlele[0][1]]
      options[0][0] = "xml"
      drv.QueryOrderInfo(options.map { |k, v| {k => {Fixnum => SOAP::SOAPInt, String => SOAP::SOAPString}[v.class].new(v)} }.inject(&:merge)).__xmlele[0][1].sub("encoding='GB2312'", "encoding='UTF-8'")
    end


    module ClassMethods

      def zjs_result(identifier) # :nodoc: all
        drv = SOAP::WSDLDriverFactory.new("http://edi.zjs.com.cn/service/query.asmx?wsdl").create_rpc_driver
        options = [
          ["strInfo", "<BatchQueryRequest> <logisticProviderID>xxxxx</logisticProviderID> <orders> <order> <orderNo>#{identifier}</orderNo> </order> </orders> </BatchQueryRequest>"],
          ["userId", "xxxx"]
        ]
        options << ["md5", drv.GetMd5(options.map { |k, v| {k => {Fixnum => SOAP::SOAPInt, String => SOAP::SOAPString}[v.class].new(v)} }.inject(&:merge)).__xmlele[0][1]]
        options[0][0] = "xml"
        drv.QueryOrderInfo(options.map { |k, v| {k => {Fixnum => SOAP::SOAPInt, String => SOAP::SOAPString}[v.class].new(v)} }.inject(&:merge)).__xmlele[0][1].sub("encoding='GB2312'", "encoding='UTF-8'")
      end

      def zjs_data(identifier) # :nodoc: all
        data = {:orginal => zjs_result(identifier)}
        data[:steps] = Nokogiri::XML(data[:orginal]).xpath("BatchQueryResponse/orders/order/steps/step").map { |step| {:time => step.xpath("acceptTime").text, :address => step.xpath("acceptAddress").text} }
        data[:received_at] = DateTime.parse(data[:steps].to_a.find { |step| step[:address].match(/已签收/) }[:time]).to_time rescue nil
        data
      end
    end
  end
end
