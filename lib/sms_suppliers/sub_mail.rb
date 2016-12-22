# {
#     status: "success",
#     send_id: "26aef567ee59d087959c04b88a9e7ad9",
#     sms_credits: 10574
# }

module SubMail
  TYPES ={
      ### [账号激活] 您的激活码是@var(content)。请在30分钟内输入激活码进行手机账号激活。
      sign_up: 'PRJlx1',
      ### [密码重置] 您的重置码是@var(content)。请在30分钟内输入重置码进行密码重置。【珀丽莱】
      re_password: 'WVty12',
      ### 尊敬的用户：您好，感谢您在珀丽莱官网订购商品，@var(content)。如有需要请致电020-3110 2227。【珀丽莱】
      shop_buy: 'yOoXn3',
      ### 尊敬的用户：您好，@var(content)。感谢您的支持，祝您生活愉快！【珀丽莱】
      service: 'zKI3N2'
  }

  class << self
    def config_data
      {
          base_url: 'https://api.submail.cn/message/xsend.json',
          data: {appid: Rails.application.secrets[:sms_id],
                 signature: Rails.application.secrets[:sms_key],
                 signtype: 'md5'}
      }
    end

    def send_msg(phone, content, type)
      result = {}
      params = config_data[:data].merge(project: TYPES[type.to_s.to_sym])
      params[:to] = phone
      params[:vars] = JSON.generate({content: content})
      RestClient::Request.execute(method: 'post', url: config_data[:base_url], payload: params) do |response|
        result = response
      end
      result
    end
  end
end
