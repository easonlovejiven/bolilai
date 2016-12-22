require 'open-uri'
require 'sms_suppliers/sub_mail'
require 'sms_suppliers/sms_bao'

module SendSms
  include SmsBao
  include SubMail

  class << self
    def send(phone, content, type)
      klass = Rails.application.secrets[:sms_supplier].classify.constantize
      begin
        klass.send_msg(phone, content, type)
      rescue Exception => ex
        {status: 'code error', code: "100", msg: ex.message}
      end
    end
  end
end