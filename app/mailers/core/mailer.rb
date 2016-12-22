class Core::Mailer < ActionMailer::Base
  default :from => %["珀丽莱" <#{::MAILER_CONFIG['from']['default']}>], :content_type => "text/html"

  def standard_mail(options = {})
    options[:date] ||= options[:sent_on]
    options[:to] ||= options[:recipients]
    [options[:attachments] || options[:attachment]].flatten.compact.each { |attachment| attachments[attachment[:filename]] = attachment }

    mail(options) do |format|
      format.html do
        if options[:template]
          (options[:body] || {}).each { |key, value| instance_variable_set("@#{key}", value) }
          render :file => "core/mailer/#{options[:template]}.html.erb", :object => options[:locals]
        else
          render :text => options[:body]
        end
      end
    end
  end

  def self.mail(options = {})
    return if (options[:to] || options[:recipients]).blank?
    self.standard_mail(options).deliver
  end
end
