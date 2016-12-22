require 'soap/wsdlDriver'
module Delivery
  module Kuaidi100
    extend ActiveSupport::Concern
    ### API http://www.kuaidi100.com/openapi/api_post.shtml
    DELIVERY_COMS ={
        zhaijisong: {name: 'zhaijisong', :title => '宅急送', show: 0},
        lianbangkuaidi: {name: 'lianbangkuaidi', :title => '联邦快递', show: 0},
        shunfeng: {name: 'shunfeng', :title => '顺丰速运', show: 0},
        ems: {name: 'ems', :title => '邮政EMS', :datatype => 'xml', show: 0}
    }

    module ClassMethods
      def delivery_coms_arr
        DELIVERY_COMS.values
      end

      def valid_express?(express)
        DELIVERY_COMS.keys.include?(express.to_s.to_sym)
      end

      def kuaidi100_result(express, identifier, show=0)
        case express
          when *%w[ems shunfeng]
            url = "http://www.kuaidi100.com/query?id=1&valicode=&type=#{express}&postid=#{identifier}"
          else
            url = "http://api.kuaidi100.com/api?id=c7f21ed53b61bf66&com=#{express}&nu=#{identifier}&show=#{show}&muti=1&order=desc"
        end
        Mechanize.new.get(url).body
      end

      def kuaidi100_data(express, identifier)
        show_type = DELIVERY_COMS[express.to_sym] && DELIVERY_COMS[express.to_sym][:show]
        title = DELIVERY_COMS[express.to_sym] && DELIVERY_COMS[express.to_sym][:title]
        result = {:orginal => kuaidi100_result(express, identifier, show_type)}
        case show_type
          when 0 ### 返回json字符串
            json_data = JSON.parse(result[:orginal]||'{}')
            result[:comcontact] = json_data['comcontact']
            result[:steps] = (json_data['data']||[]).map { |v| {time: v['time'], location: v['location'], context: v['context']} }
          when 1 ### 返回xml对象
            xml_data = Nokogiri::XML(result[:orginal]).xpath("/xml")
            result[:comcontact] = xml_data.xpath('comcontact').text
            result[:steps] = xml_data.xpath('data').map { |step| {time: step.xpath('time').text, location: step.xpath('location').text, context: step.xpath('context').text} }
          when 2 ### 返回html对象
            html_data = Nokogiri::XML(result[:orginal]).xpath("//table/tr")
            result[:steps] = html_data.map { |step| td = step.xpath('td'); {time: td.try(:[], 0).try(:text), context: td.try(:[], 1).try(:text)} }
          when 3 ### 返回text文本
            result[:steps_context] = result[:orginal]
          else
            result[:steps_context] = '参数错误'
        end
        result[:nu] = identifier
        result[:title] = title
        result
      end
    end
  end
end