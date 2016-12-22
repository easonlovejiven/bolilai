class Core::Connection < ActiveRecord::Base # :nodoc: all
	self.table_name= :core_connections

	belongs_to :account
	has_many :contacts, ->{where( :active => true) }

	scope :active,->{ where(:active => true) }

	self.xml_options = { :except => [ :active, :token, :secret ] }

	def refresh_token!
		config = OAUTH_CONFIG[self.site]
		case self.site
		when 'wechat'
			refresh_token_option = {
				appid: PAYMENT_CONFIG[self.site]['appid'],
				grant_type: 'refresh_token',
				refresh_token: self.refresh_token.to_s,
			}
			resp_refresh_token = JSON.parse Timeout::timeout(30){ HTTParty.get("#{config['refresh_token_path']}?#{refresh_token_option.map{|k, v|"#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join('&')}").body }
			raise ActiveResource::ResourceInvalid if resp_refresh_token['errcode'].present?
			self.expired_at = Time.now + resp_refresh_token['expires_in'].to_i
			self.save
		end
	end
end
