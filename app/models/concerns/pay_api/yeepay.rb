module PayApi
  module Yeepay
    YEEPAY_BANKS = [
      {name: 'ICBC-NET', title: '工商银行'},
      {name: 'ICBC-WAP', title: '工商银行WAP'},
      {name: 'CMBCHINA-NET', title: '招商银行WAP'},
      {name: 'CMBCHINA-WAP', title: '招商银行WAP'},
      {name: 'ABC-WAP', title: '中国农业银行'},
      {name: 'CCB-NET', title: '建设银行'},
      {name: 'CCB-PHONE', title: '建设银行WAP'},
      {name: 'BCCB-NET', title: '北京银行'},
      {name: 'BOCO-NET', title: '交通银行'},
      {name: 'CIB-NET', title: '兴业银行'},
      {name: 'NJCB-NET', title: '南京银行'},
      {name: 'CMBC-NET', title: '中国民生银行'},
      {name: 'CEB-NET', title: '光大银行'},
      {name: 'BOC-NET', title: '中国银行'},
      {name: 'PAB-NET', title: '平安银行'},
      {name: 'CBHB-NET', title: '渤海银行'},
      {name: 'HKBEA-NET', title: '东亚银行'},
      {name: 'NBCB-NET', title: '宁波银行'},
      {name: 'ECITIC-NET', title: '中信银行'},
      {name: 'SDB-NET', title: '深圳发展银行'},
      {name: 'GDB-NET', title: '广东发展银行'},
      {name: 'SPDB-NET', title: '上海浦东发展银行'},
      {name: 'POST-NET', title: '中国邮政'},
      {name: 'BJRCB-NET', title: '北京农村商业银行'}
    ]

    YEEPAY_CREDITCARD_BANK = [
      {name: 'JUNNET-NET', title: '骏网一卡通'},
      {name: 'SNDACARD-NET', title: '盛大卡'},
      {name: 'SZX-NET', title: '神州行'},
      {name: 'ZHENGTU-NET', title: '征途卡'},
      {name: 'QQCARD-NET', title: 'Q币卡'},
      {name: 'UNICOM-NET', title: '联通卡'},
      {name: 'JIUYOU-NET', title: '久游卡'},
      {name: 'YPCARD-NET', title: '易宝e卡通'},
      {name: 'NETEASE-NET', title: '网易卡'},
      {name: 'WANMEI-NET', title: '完美卡'},
      {name: 'SOHU-NET', title: '搜狐卡'},
      {name: 'TELECOM-NET', title: '电信卡'}
    ]

    YEEPAY_DIRECT_CONNECT_BANK = [
      {name: 'HXB-NET', title: '华夏银行'},
      {name: 'GNXS-NET', title: '广州市农村信用合作社'},
      {name: 'GZCB-NET', title: '广州市商业银行'},
      {name: 'SDE-NET', title: '顺德农信社'},
      {name: 'SHRCB-NET', title: '上海农村商业银行'}
    ]

    YEEPAY_PREPAID_CARD = [
      {name: 'Ybt-NET', title: '中欣银宝通卡'},
      {name: 'Aixin-NET', title: '爱心卡'},
      {name: 'AllScore-NET', title: '奥斯卡'},
      {name: 'Dazhong-NET', title: '大众e通卡'},
      {name: 'HUILIAN-NET', title: '国华汇联'},
      {name: 'GXJFT-NET', title: '集付宝'},
      {name: 'JXJiaofeitong-NET', title: '江西缴费通卡'},
      {name: 'JIANGSRX-NET', title: '瑞祥商联'},
      {name: 'Slsy-NET', title: '商联商用'},
      {name: 'Shangmeng-NET', title: '商盟统统付'},
      {name: 'WSTONGLIAN-NET', title: '万商通联'},
      {name: 'Yikahui-NET', title: '壹卡会'},
      {name: 'Edenred-NET', title: '雅高e卡'},
      {name: 'Bohaiyisheng-NET', title: '易生如意卡'},
      {name: 'Yitong-NET', title: '1039易通卡'},
      {name: 'Zhongfutong-NET', title: '城市通卡'}
    ]

    def query_yeepay! # :nodoc: all
      return false unless self.status == 'pay'
      r = self.yeepay_result
      self.audit!(:payment_service => "yeepay", :payment_identifier => r['r2_TrxId']) if r && r['rb_PayStatus'] == 'SUCCESS' && r['r3_Amt'].to_i == self.payment_price.to_i
    end

    def yeepay_result # :nodoc: all
      options = {p0_Cmd: 'QueryOrdDetail', p1_MerId: PAYMENT_CONFIG['yeepay']['merId'], p2_Order: self.id}
      options.merge!(hmac: HMAC::MD5.new(PAYMENT_CONFIG['yeepay']['securityKey']).update(options.values.join).to_s)
      data = {}
      Timeout::timeout(10) { Mechanize.new.get(URI.parse(PAYMENT_CONFIG['yeepay']['queryUrl']), options).body }.split("\n").map { |a| data[a.split("=")[0]] = a.split("=")[1] }
      data
    end

    def yeepay_checkout_url(brank = nil)
      options = {
        p0_Cmd: 'Buy',
        p1_MerId: PAYMENT_CONFIG['yeepay']['merId'],
        p2_Order: self.id,
        p3_Amt: '%.2f' % self.payment_price,
        p4_Cur: 'CNY',
        p5_Pid: 'weimall.com',
        p8_Url: "http://#{HOSTS['dynamic']}/shop/trades/#{self.id}/yeepay_return",
        p9_SAF: '0',
        pd_FrpId: brank ? brank : '',
        pr_NeedResponse: '1'
      }
      yeepay_url(PAYMENT_CONFIG['yeepay']['yeepayCommonReqURL'], options, brank && YEEPAY_PREPAID_CARD.map { |h| h[:name] }.include?(brank))
    end

    def yeepay_url(action, options, kypGateway=false) # :nodoc:
      options.merge!(hmac: HMAC::MD5.new(PAYMENT_CONFIG['yeepay']['securityKey']).update(options.values.join).to_s)
      options.merge!(kypGateway: 'kypGateway') if kypGateway
      "#{action}?#{options.sort.map { |k, v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s).encode('utf-8', 'gbk')}" }.join('&')}"
    end
  end
end
