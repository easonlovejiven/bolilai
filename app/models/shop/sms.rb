##
# = 商城 短信 表
#
# == Fields
#
# editor_id :: 编辑ID
# trade_id :: 交易ID
# costumer_id :: 顾客ID
# phone :: 手机
# content :: 内容
# remark :: 备注
# send_at :: 发送时间
# success? :: 发送？
# active? :: 有效？
#
# == Indexes
#
require 'digest/md5'
require 'open-uri'
class Shop::Sms < ActiveRecord::Base
  self.table_name = :shop_smss

  belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
  belongs_to :trade
  belongs_to :costumer
  belongs_to :user

  scope :active, -> { where :active => true }
  scope :success, -> { where :success => true }

  TEMPLATES = [
      {:name => %[发票提示类：联系不到需确认], :content => %[尊敬的用户：您好，感谢您在珀丽莱官网订购商品，申请发票过程中发现需要与您确认的情况，客服致电未能与您取得联系，期待您看到短信后来电与我们沟通，在确认到您的意见之前，发票将暂不开具，请您谅解。如有疑问请致电020-3110 2227 www.barlar.cn/l/428077], },
      {:name => %[发票提示类：发票退回联系不到], :content => %[尊敬的用户：您好，珀丽莱官网为您递送的发票今天被退回，物流反馈因无法联系到您递送失败，客服致电未能与您取得联系，现将发票保留，若24小时内没有得到您的回复，我们将先行安排发票退至财务部做作废处理。如有疑问请致电020-3110 2227 www.barlar.cn/l/428078], },
      {:name => %[发票提示类：发票发出提示], :content => %[尊敬的用户：您好，感谢您在珀丽莱官网选购商品，您要求的发票今天已通过宅急送快递发出，请注意查收。如有需要请致电020-3110 2227。 www.barlar.cn/l/428079], },
      {:name => %[退换货提示类：银行信息不准确提醒], :content => %[尊敬的用户：您好，您退回的商品已经验收入库，财务反馈您提供的银行卡信息有误，导致无法成功退款。客服致电未能与您取得联系，期待您看到短信后及时与我们联系确认退款信息。如有需要请致电020-3110 2227 www.barlar.cn/l/428080], },
      {:name => %[退换货提示类：申请退款提醒], :content => %[尊敬的用户：您好，您退回的商品已经验收入库，财务反馈您未操作退货申请，导致无法及时退出款项。客服致电未能与您取得联系，期待您看到短信后来电与我们沟通。在确认到您的退款信息之前，我们将暂不操作退款。如有需要请致电020-3110 2227 www.barlar.cn/l/428081], },
      {:name => %[退换货提示类：提交申请联系不到], :content => %[尊敬的用户：您好，您于珀丽莱官网提交的退货申请已经被关注，客服致电未能与您取得联系，期待您看到短信后来电与我们沟通，确认此退货申请并为您安排取件。如未能在7天退换货期限内确认到您的意见，商品将无法再进行退换货。如有需要请致电020-3110 2227 www.barlar.cn/l/428082], },
      {:name => %[退换货提示类：客服邮箱（北京）], :content => %[尊敬的用户：您好，珀丽莱官网XXXX号温馨提示：请您将商品图片发送至info@barlar.cn，收到图片后我们会及时与您取得联系，感谢您的理解和支持。如有需要请致电020-3110 2227 www.barlar.cn/l/428083], },
      {:name => %[银行订单提示类：退款提醒], :content => %[尊敬的用户：您好，您退回的商品已经验收入库，我司已在招行订单后台完成退款操作，根据招行的退款流程，到账时间为7个工作日，信用卡恢复额度为15个工作日，您可致电招行客服咨询确认。如有疑问请致电020-3110 2227 www.barlar.cn/l/428084], },
      {:name => %[银行订单提示类：订单发货提示], :content => %[尊敬的用户您好：您的订单已经通过XX快递发货，运单号XXXX。请您注意查收，如有需要请致电020-3110 2227。 www.barlar.cn/l/428085], },
      {:name => %[银行订单提示类：联系不到顾客], :content => %[尊敬的用户：您好，感谢您关注招行信用卡商城中珀丽莱官网在售商品，客服致电未能与您取得联系，期待您看到短信后来电与我们沟通。如有需要请致电珀丽莱官网客服热线020-3110 2227。坐席XXXX号竭诚为您服务 www.barlar.cn/l/428086], },
      {:name => %[物流提示类：订单无法COD], :content => %[尊敬的用户：您好，感谢您在珀丽莱官网订购商品，物流供应商反馈您填写的地址不支持货到付款业务，客服致电未能与您取得联系，期待您看到短信后来电与我们沟通，若24小时内没有确认到您的意见，我们将先行取消订单。如有需要请致电020-3110 2227 www.barlar.cn/l/428087], },
      {:name => %[物流提示类：拒签商品联系不到], :content => %[尊敬的用户：您好，您在珀丽莱官网订购的商品已经到达目的地，物流反馈商品签收失败，我们希望了解到是否有需要协调或改善的地方，客服致电未能与您取得联系，期待您看到短信后来电与我们沟通，帮助我们提升服务。商品将暂时保留在当地站点，若48小时内没有确认到您的意见，我们将先行安排商品退回珀丽莱库房。如有需要请致电020-3110 2227 www.barlar.cn/l/428088], },
      {:name => %[物流提示类：联系不到无法派送], :content => %[尊敬的用户：您好，您在珀丽莱官网订购的商品已经到达目的地，物流反馈因无法联系到您递送失败，客服致电未能与您取得联系，现将商品保留在当地站点等待您通知，若48小时内没有得到您的回复，我们将先行安排商品退回珀丽莱库房。如有需要请致电020-3110 2227 www.barlar.cn/l/428089], },
      {:name => %[物流提示类：安排返件], :content => %[尊敬的用户：您好，您在珀丽莱官网订购的商品已经到达目的地，物流反馈商品未成功签收，客服致电未能与您取得联系，短信提示已过48小时，今天将安排商品退回。如有疑问请致电020-3110 2227 www.barlar.cn/l/428090], },
      {:name => %[网站提示类：首次购物], :content => %[尊敬的用户：您好，感谢您对珀丽莱官网的信任，为保证您的权益，您选购的商品可享受收货7天内，在商品原包装完好、原装吊牌及珀丽莱吊牌完好悬挂的情况下，免费退换货的服务（个别特殊品类商品无法退换货，具体以商品描述提示及客服提示为准）。温馨提示您在签收商品时进行检查，在确认商品不退换之前，不对商品包装及配件做处理，如有疑问或退换货需求请您致电020-3110 2227详询 。访问手机版随时购物： m.barlar.cn/2befw], },
      {:name => %[网站提示类：返件地址（天津）], :content => %[尊敬的用户：您好，珀丽莱官网天津库地址信息：天津经济技术开发区百合路71号珀丽莱官网退货组收；邮编：300457；联系电话：020-3110 2227；收件人：珀丽莱官网。如有疑问请致电020-3110 2227 www.barlar.cn/l/428092], },
      {:name => %[网站提示类：返件地址（北京）], :content => %[尊敬的用户：您好，珀丽莱官网北京库地址信息：北京市朝阳区裕民路12号中国国际科技会展中心B座1101；邮编：100029；联系电话：020-3110 2227；收件人：珀丽莱官网。如有疑问请致电020-3110 2227 www.barlar.cn/l/428093], },
      {:name => %[网站提示类：汇款账号], :content => %[尊敬的用户：您好，珀丽莱官网账号信息——公司名称：天津网聚珀丽莱官网络科技有限公司；公司账号：122 903 697 810 802；珀丽莱开户行名称：？？？。如有疑问请致电020-3110 2227 www.barlar.cn/l/428094], },
      {:name => %[网站提示类：客服邮箱], :content => %[尊敬的用户：您好，珀丽莱官网客服XXXX号温馨提示：请您将商品图片以“商品名+照片+收货人手机号”为主题发邮件至info@barlar.cn，尽可能清晰体现商品瑕疵部位和吊牌的情况。收到图片后将尽快确认处理意见，并及时告知您，感谢您的理解和支持。如有需要请致电020-3110 2227 www.barlar.cn/l/428095], },
      {:name => %[网站提示类：货到付款联系不到], :content => %[尊敬的用户：您好，感谢您在珀丽莱官网订购商品，货到付款订单需要电话确认具体信息，客服致电未能与您取得联系，期待您看到短信后来电与我们沟通，若24小时内没有确认到您的意见，我们将先行取消订单。如有需要请致电020-3110 2227。 www.barlar.cn/l/428096], },
      {:name => %[网站提示类：维修商品发货提示], :content => %[尊敬的用户：您好，珀丽莱售后服务客服温馨提示：您的商品已经修复，将于今天使用xx快递寄出，运单号xxxxxxx，请您查收。如有需要请致电020-3110 2227 www.barlar.cn/l/428097], },
      {:name => %[网站提示类：商品瑕疵联系不到], :content => %[尊敬的用户：您好，感谢您在珀丽莱官网订购商品，出库过程中发现商品存在需要与您确认的情况，客服致电未能与您取得联系，期待您看到短信后来电与我们沟通，若24小时内没有确认到您的意见，我们将先行取消订单。如有需要请致电020-3110 2227 www.barlar.cn/l/428098], },
      {:name => %[网站提示类：在线咨询补货回复], :content => %[尊敬的用户：您好，感谢您关注珀丽莱官网，您的在线留言已经被关注。您咨询的商品目前已经售罄，建议您在商品页面点击到货通知，如果到货系统将短信或邮件通知您。同时我们也会不断补充新商品上架，欢迎您随时关注和选购。如有需要请致电020-3110 2227。访问手机版随时购物： m.barlar.cn/2bege], },
      {:name => %[网站提示类：退货返还代金券提示], :content => %[尊敬的用户：您好，您退回的商品已经验收入库，订单中所使用的代金券已经返还至您的账户，请查收并在有效期内使用。如有疑问请致电020-3110 2227。进入手机版立即查看代金券： m.barlar.cn/2begd], },
      {:name => %[网站提示类：活动现金券/代金券提示], :content => %[尊敬的用户您好，感谢您参与珀丽莱官网XXXX活动，现金券/代金券现已发放至您账户，请查收在有效期内使用。如有疑问请致电客服热线：020-3110 2227。进入手机版立即查看代金券： m.barlar.cn/2begc], },
      {:name => %[网站提示类：购买手表提示], :content => %[尊敬的用户：您好，感谢您对珀丽莱的信任并选购商品。您本次选购的商品手表属精密仪器类，一经签收无质量问题概不退换。请您在签收商品时注意开箱验货（请勿打开手表表膜），确认选购商品的准确性，如有异常请拒签并与我们取得联系。商品签收后如发现质量问题请速致电020-3110 2227向客服反馈，我们将为您做特别的退换货申请。感谢您的理解和支持！ www.barlar.cn/l/428102], },
      {:name => %[网站提示类：特殊商品购物提醒], :content => %[尊敬的用户：您好，感谢您对珀丽莱的信任并选购商品。您本次选购商品属特殊品类，一经签收无质量问题概不退换。请您在签收商品时注意开箱验货（请勿打开商品本身的包装），确认选购商品的准确性，如有异常请拒签并与我们取得联系。商品签收后如发现质量问题请致电020-3110 2227向客服反馈，我们将为您做特别的退换货申请。感谢您的理解和支持！ www.barlar.cn/l/428103], },
      {:name => %[网站提示类：汇款账号1], :content => %[尊敬的用户：您好，珀丽莱官网账号信息——公司名称：天津珀丽莱悦购商贸有限公司；公司账号：122903842910503；珀丽莱开户行名称：？？？。如有疑问请致电020-3110 2227], },
      {:name => %[网站提示类：汇款账号2], :content => %[尊敬的用户：您好，珀丽莱官网账号信息——公司名称：天津网聚珀丽莱官网络科技有限公司；公司账号12001835200052504874；珀丽莱开户行名称：？？？。如有疑问请致电020-3110 2227], },
      {:name => %[VIP用户提示类：多次无人接听电话客户], :content => %[尊敬的用户：您好！恭喜您已经成为珀丽莱官网紫金汇VIP会员！现诚意奉上500元现金礼券，可用于全网商品。金卡会员可以享受全网非特例商品95折优惠以及生日现金券等会员权益，欢迎致电4008816609转专项客服XXX了解更多精彩VIP会员权益。感谢您对珀丽莱官网的关注和支持！进入手机版立即查看现金礼券： m.barlar.cn/2begj], },
      {:name => %[VIP用户提示类：金卡升级短信], :content => %[尊敬的用户：您好！恭喜您已经成为珀丽莱官网紫金汇VIP会员！现诚意奉上500元现金 礼券，已打入您的珀丽莱官网帐户，截至使用日期到xx年xx月xx日，请查收并在有效期内使用，过期不能申补。有任何问题欢迎致电020-3110 2227 转专项客服xx，感谢您对珀丽莱官网的关注和支持！进入手机版立即查看现金礼券： m.barlar.cn/2begl], },
      {:name => %[VIP用户提示类：VIP体验], :content => %[尊敬的用户：您好，感恩与您同行，尊贵邀您共享。您的账号通过优选，已升级至VIP 体验权限，xx年xx月xx日日前可享受全网非特例商品的九五折、专属客服以及礼品包装等权益。在此期间，我是您的VIP客服，我叫XX，欢迎您随时致电 020-3110 2227，祝您生活愉快！访问手机版随时享受VIP体验特权： m.barlar.cn/2begn], },
      {:name => %[VIP用户提示类：金卡升级白金短信1], :content => %[尊敬的VIP顾客，您好，恭喜您升级成为珀丽莱官网白金卡会员，1500元升级现金券已经发放至您珀丽莱帐户，有效期至XX年XX月XX日，请您在有效日期内使用，感谢您对珀丽莱官网的关注和支持！祝您生活愉快！进入手机版立即查看现金券： m.barlar.cn/2begp], },
      {:name => %[VIP用户提示类：金卡升级白金短信2], :content => %[尊敬的用户：您好！感谢您对珀丽莱官网的关注和支持！您已经升级成为我们的白金卡会员，在网站购物可以享受大部分商品九折优惠，1500元现金券已经发放至 您帐户，不可以和基因值、代金券和白金卡折扣同时使用，有效期至XX年XX月XX日，可以以500为基数拆分合并，请您在有效期内使用，如有疑问，欢迎致 电020-3110 2227联系您的专项客服，祝您生活愉快！进入手机版立即查看现金券： m.barlar.cn/2begp], },
      {:name => %[客户关怀类：客户关怀发货提醒], :content => %[尊敬的用户：您好，为感谢您对珀丽莱官网的支持，我们为您准备了一份小礼物，包裹将于48小时内发出，请您注意查收。如有疑问请致电020-3110 2227 www.barlar.cn/l/428104], },
      {:name => %[客户关怀类：客户回访感谢短信], :content => %[尊敬的用户：您好，非常感谢您对珀丽莱官网回访工作的支持！我们致力于为您提供更优质的服务，如您对珀丽莱官网有任何意见或建议，欢迎随时致电客服热线：020-3110 2227 www.barlar.cn/l/428105], },
      {:name => %[促销活动类：幸运大转盘活动提示短信], :content => %[尊敬的用户您好:感谢您参与珀丽莱官网年终大促之幸运大转盘活动，您获得的抽奖码如下：XXXXXXXXXX。您可登录到活动页面，填写活动码进行抽奖，祝您好运！如有需要请致电020-3110 2227。 www.barlar.cn/l/428106], },
  ]

  def send_by!(type, editor = nil, channel = nil) #:nodoc: all
    raise "already sent before" if self.success?
    self.class.send_sms(phone, content, type)
    self.update_attributes!(:success => true, :editor_id => editor && editor.id, :send_at => Time.now)
    self
  end

  class << self
    def api(method, params = {}) #:nodoc: all
      # options = SMS_CONFIG['high']
      # client = Savon::Client.new(options['gateway'])
      # Timeout::timeout(20) { client.request(:wsdl, method) { soap.body = ([options['serial'], options['key']] + params[:params].to_a).each_with_index.map { |param, i| {"arg#{i}" => param} }.inject({}, &:merge) } }.to_hash
    end

    # public int sendSMS(String softwareSerialNo, String key, String sendTime,
    #   String[] mobiles, String smsContent, String addSerial,
    #   String srcCharset, int smsPriority,long smsID)
    def send_sms(phone, content, type) #:nodoc: all
      raise 'invalid sms parameters' unless type.present? && !content.blank? && !phone.blank? && phone.to_sz.map { |p| p.to_s =~ /1\d{10}/ }.inject(&:&)
      response = ::SendSms.send(phone, content, type)
      # response = api :sendSMS, {params: [nil, phone.to_sz.map(&:to_s), content, nil, 'UTF-8', 5, 0], channel: channel}
      # raise response.values.first[:return] unless response.values.first[:return] == '0'
    end

    # public double getBalance(String softwareSerialNo, String key)throws Exception
    def get_balance(channel = nil) #:nodoc: all
      response = api :getBalance
      response.values.first[:return].to_f
    end

    # public double getEachFee(String softwareSerialNo, String key)
    def get_each_fee(channel = nil) #:nodoc: all
      response = api :getEachFee
      response.values.first[:return].to_f
    end

    # public int registEx(String softwareSerialNo, String key, String serialpass)
    def regist_ex(channel = nil) #:nodoc: all
      options = SMS_CONFIG[channel || 'normal']
      response = api :registEx, {params: [options['password']], channel: channel}
      raise response.values.first[:return] unless response.values.first[:return] == '0'
    end

    # public int logout(String softwareSerialNo, String key)
    def logout(channel = nil) #:nodoc: all
      response = api :logout
      raise response.values.first[:return] unless response.values.first[:return] == '0'
    end
  end
end
