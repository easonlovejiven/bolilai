#ActionMailer::Base Config
ActionMailer::Base.default_url_options = {:host => "http://#{MAILER_CONFIG["domain"]}"}
ActionMailer::Base.asset_host = "http://#{MAILER_CONFIG["domain"]}"
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = MAILER_CONFIG.map{ |k, v| {k.to_sym => v} }.inject(&:merge)


