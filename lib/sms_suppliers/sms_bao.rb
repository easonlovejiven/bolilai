require 'digest/md5'

module SmsBao
  SMS_STATUS = {
      '-1' => 'authentication fails',
      '0' => 'success',
      '30' => 'password error',
      '40' => 'bad account',
      '41' => 'no money',
      '42' => 'account expired',
      '43' => 'IP denied',
      '50' => 'content sensitive',
      '51' => 'bad phone number',
  }
  TYPES ={
      sign_up: '[账号激活] 您的激活码是@sms_content。请在30分钟内输入激活码进行手机账号激活。【伟亚科技官网】',
      re_password: '[密码重置] 您的重置码是@sms_content。请在30分钟内输入重置码进行密码重置。【伟亚科技官网】',
      shop_buy: '尊敬的用户：您好，感谢您在珀丽莱官网订购商品，@sms_content。如有需要请致电020-3110 2227。【伟亚科技官网】',
      service: '尊敬的用户：您好，@sms_content。感谢您的支持，祝您生活愉快!【伟亚科技官网】'
  }

  class << self
    def config_data
      {
          base_url: 'http://www.smsbao.com/sms',
          data: {u: Rails.application.secrets[:sms_id],
                 p: Digest::MD5.hexdigest(Rails.application.secrets[:sms_key])
          }
      }
    end

    ### http://www.smsbao.com/sms?u=hoxf&p=823f199f718c967af3a77fc214f8b0b9&m=13121684460&c=test
    def send_msg(phone, content, type)
      result = {}
      params = config_data[:data]
      params[:m] = phone
      params[:c] = TYPES[type.to_sym].gsub('@sms_content', content)
      RestClient::Request.execute(method: 'get', url: config_data[:base_url], headers: {params: params}) do |response|
        result = {status: SMS_STATUS[response], code: response}
      end
      result
    end
  end
end
