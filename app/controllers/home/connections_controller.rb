##
# = 主站 连接 界面
#
class Home::ConnectionsController < Home::ApplicationController

	##
	# == 新建
	#
	# === Request
	#
	# ==== Resource
	#
	# GET /connections/new
	#
	# ==== Parameters
	#
	# site :: 网站，必须为%w[live sina douban google alipay tianji comm qq qqcb alipay_wallet wechat]之一
	# redirect :: 跳转地址
	# type :: 连接类型，可为%w[default binding]之一，默认为 default，会自动创建账户；binding不会创建账户。
  # !!for weixin
  #   scope :: 域类型，可为%w[snsapi_base snsapi_userinfo]之一，默认为 snsapi_userinfo，参数名可统一为：type
	#
	# === Response
	#
	# ==== HTML
	#
	# 重定向到外部网站
	#
	# ==== JSON
	#
	#   {
	#     "url": 地址,
	#   }
	#
	def new
		site = params[:site].to_s
		redirect = params[:redirect].to_s
		config = OAUTH_CONFIG[site]
		callback = "http://#{request.domain(999)}/connections/callback?site=#{CGI::escape(site)}&redirect=#{CGI::escape(redirect)}&type=#{CGI::escape(params[:type].to_s)}"
		case site
		when 'live'
			authorize_url = "https://login.live.com/oauth20_authorize.srf?client_id=#{CGI::escape(config['key'])}&display=popup&locale=zh-Hans&scope=wl.signin%20wl.basic&response_type=code&redirect_uri=#{CGI::escape(callback)}"
		when 'sina'
			@consumer = OAuth::Consumer.new(config['key'], config['secret'], {
				:site               => config['site'],
				:request_token_path => config['request_token_path'],
				:access_token_path  => config['access_token_path'],
				:authorize_path     => config['authorize_path'],
				:signature_method   => 'HMAC-SHA1',
				:scheme             => :header,
				:http_method        => :post,
				:realm              => "http://#{HOSTS['dynamic']}",
			})
			@request_token = @consumer.get_request_token
			session[:request_token] = @request_token
			authorize_url = @request_token.authorize_url :oauth_callback => callback
		when 'google'
			@consumer = OAuth::Consumer.new(config['key'], config['secret'], {
				:site               => config['site'],
				:request_token_path => config['request_token_path'],
				:access_token_path  => config['access_token_path'],
				:authorize_path     => config['authorize_path'],
				:signature_method   => 'HMAC-SHA1',
				:scheme             => :header,
				:http_method        => :post,
				:realm              => "http://#{HOSTS['dynamic']}",
			})
			@request_token = @consumer.get_request_token({:scope=> "https://www.google.com/m8/feeds/",:oauth_callback => callback})
			session[:request_token] = @request_token
			authorize_url = @request_token.authorize_url
		when 'alipay'
			@consumer = {
				'service' => 'alipay.auth.authorize',
				'return_url' => callback,
				'target_service' => 'user.auth.quick.login',
				'_input_charset' => 'utf-8',
				'partner' => config['account']
			}
			@consumer.merge!({
				'sign_type' => 'MD5',
				'sign' => Digest::MD5.hexdigest(@consumer.sort.map{|k,v|"#{k}=#{v}"}.join("&")+config['key']),
			})

			authorize_url = "#{config['site']}#{config['authorize_path']}?#{@consumer.sort.map{|k, v|"#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join('&')}"
		when 'tianji'
			@consumer = {
				'response_type' => 'code',
				'client_id' => config['key'],
				'redirect_uri' => callback,
			}
			authorize_url = "#{config['site']}#{config['authorize_path']}?#{@consumer.map{|k, v|"#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join('&')}"
		when 'comm'
			@consumer = {
				'tpi' => config['tpi'],
				'timestamp' => Time.now.to_i,
				'backURL' => callback
			}
			authorize_url = "#{config['site']}?format=JSON&sign=#{CGI::escape(Digest::MD5.hexdigest(@consumer.to_json + config['salt']))}&plaintext=#{CGI::escape(@consumer.to_json)}"
		when 'qq'
			options = {
				:response_type => 'code',
				:client_id => config['key'],
				:redirect_uri => callback,
				:state => callback
			}
			authorize_url = "#{config['site']}#{config['authorize_path']}?#{options.map{|k,v| "#{k}=#{CGI::escape(v)}"}.join('&')}"
		when 'alipay_wallet'
			options = {
				'partner' => PAYMENT_CONFIG['alipay']['account'],
				'app_name' => 'mc',
				'biz_type' => 'trust_login',
				'notify_url' => "http://#{HOSTS['dynamic']}/connections/callback.json?site=alipay_wallet",
			}
			key = OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['alipay']['client_private_key'])
			options.merge!({
				'sign_type' => 'RSA',
				'sign' => CGI::escape(Base64.encode64(key.sign(OpenSSL::Digest::SHA1.new, options.map{|k,v| "#{k}=\"#{v}\"" }.join('&'))).gsub("\n", '')),
			})
			authorize_url = options.map{|k,v| "#{k}=\"#{v}\"" }.join('&')
		when 'wechat'
      scope = params[:scope].blank? ? 'snsapi_userinfo' : params[:scope] # 改动 1，scope值的两种设置
			options = {
				appid: PAYMENT_CONFIG[site]['appid'],
				redirect_uri: push_param(callback, "scope=#{scope}"),
				response_type: 'code',
        # scope: 'snsapi_userinfo',
				scope: scope, # 改动 2
			}
			authorize_url = "#{config['authorize_path']}?#{options.map{|k, v|"#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join('&')}#wechat_redirect"
		end
		respond_to do |format|
			format.html { redirect_to authorize_url if authorize_url }
			format.xml { @data = { 'url' => authorize_url } }
		end
	end

	def callback # :nodoc:
		site = params[:site].to_s
		redirect = params[:redirect].to_s
		config = OAUTH_CONFIG[site]
		callback = "http://#{request.domain(999)}/connections/callback?site=#{CGI::escape(site)}&redirect=#{CGI::escape(redirect)}"

		case site
		when 'live'
			resp = HTTParty.post("https://login.live.com/oauth20_token.srf", :body => { "client_id" => config['key'], "client_secret" => config['secret'], "redirect_uri" => callback, "code" => params[:code], "grant_type" => "authorization_code" })
			access_token = resp['access_token']
			resp = HTTParty.get("https://apis.live.net/v5.0/me?access_token=#{CGI::escape(access_token)}")
			raise 'invalid identifier' if resp['id'].blank?
			@connection = Core::Connection.active.find_or_initialize_by_site_and_identifier(site, resp['id'])
			@connection.token = access_token
			@connection.name = resp['name']
			@connection.save
		when 'douban'
			@access_token = session[:request_token].get_access_token

			@connection = Core::Connection.find_or_initialize_by_site_and_identifier_and_active(site, @access_token.params[:douban_user_id], true)
			@connection.token = @access_token.token
			@connection.secret = @access_token.secret
			@connection.save

			@api_access_token = OAuth::AccessToken.new(OAuth::Consumer.new(config['key'], config['secret'], {
				:site               => 'http://api.douban.com',
				:signature_method   => 'HMAC-SHA1',
				:scheme             => :header,
				:http_method        => :post,
				:realm              => "http://#{HOSTS['dynamic']}",
			}), @connection.token, @connection.secret)

			resp = Crack::XML.parse(@api_access_token.get("/people/#{@connection.identifier}").body)
			@connection.data = resp.to_json
			@connection.name = resp['entry']['title']
			@connection.pic = resp['entry']['link'].find{|h|h['rel']=='icon'}['href']
			@connection.save

			resp = Crack::XML.parse(@api_access_token.get("/people/#{@connection.identifier}/contacts?start-index=0&max-results=999").body)

      entrys = resp['feed']['entry'].class.name == 'Hash' ? [resp['feed']['entry']] : resp['feed']['entry'].to_sz

			entrys.each do |entry|
				@contact = @connection.contacts.find_or_initialize_by_identifier(entry['id'].sub('http://api.douban.com/people/', ''))
				@contact.name = entry['title']
				@contact.pic = entry['link'].find{|h|h['rel']=='icon'}['href']
				@contact.data = entry.to_json
				@contact.save
			end

		when 'sina'
			@access_token = session[:request_token].get_access_token(:oauth_token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier])

			@connection = Core::Connection.find_or_initialize_by_site_and_identifier_and_active(site, @access_token.params[:user_id], true)
			@connection.token = @access_token.token
			@connection.secret = @access_token.secret
			@connection.save

			resp = ActiveSupport::JSON.decode(@access_token.get('/account/verify_credentials.json').body)
			@connection.data = resp.to_json
			@connection.name = resp['name']
			@connection.sex = (resp['gender'] == 'm') ? 'male' : 'female'
			@connection.pic = resp['profile_image_url']
			@connection.save

			# resp = ActiveSupport::JSON.decode(@access_token.get('/statuses/friends.json').body)
			# resp.each do |entry|
			# 	@contact = @connection.contacts.find_or_initialize_by_identifier(entry['id'])
			# 	@contact.name = entry['name']
			# 	@contact.sex = (entry['gender'] == 'm') ? 'male' : 'female'
			# 	@contact.pic = entry['profile_image_url']
			# 	@contact.data = entry.to_json
			# 	@contact.save
			# end
		when 'google'
			@access_token = session[:request_token].get_access_token(:oauth_token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier])
			resp = Crack::XML.parse(@access_token.get("https://www.google.com/m8/feeds/contacts/default/full").body)
			@connection = Core::Connection.find_or_initialize_by_site_and_identifier_and_active(site, resp['feed']['id'], true)
			@connection.token = @access_token.token
			@connection.secret = @access_token.secret
			@connection.data = resp.to_json
			@connection.name = resp['feed']['author']['name']
			@connection.save
			resp['feed']['entry'].each{|entry|
				@contact = @connection.contacts.find_or_initialize_by_identifier(entry['gd:email']['address'])
				@contact.name = entry['title']
				@contact.data = entry.to_json
				@contact.save
			}
		when 'alipay'
			if params['is_success'] == 'T' && params['sign'].downcase == Digest::MD5.hexdigest(params.slice(*%w[_input_charset is_success notify_id real_name token user_id]).sort.map{|k,v| "#{k}=#{k == 'notify_id' ? v : CGI.unescape(v)}" }.join("&")+config['key'])
				@connection = Core::Connection.find_or_initialize_by_site_and_identifier_and_active(site, params['user_id'], true)
				@connection.token = params['token']
				@connection.name = params['real_name']
				@connection.save
			end
		when 'alipay_wallet'
			render text: "success", layout: false
			return
		when 'tianji'
			resp = Timeout::timeout(30){HTTParty.post("#{config['site']}#{config['access_token_path']}", :body => { "grant_type" => "authorization_code", "client_id" => config['key'], "client_secret" => config['secret'], "redirect_uri" => callback, "code" => params[:code] })}
			if resp.response && resp.response.msg && resp.response.msg == "OK"
				resp_get_info = Timeout::timeout(30){HTTParty.get("https://api.tianji.com/me?access_token=#{resp['access_token']}")}
				if resp_get_info.response && resp_get_info.response.msg && resp_get_info.response.msg == "OK"
					@connection = Core::Connection.find_or_initialize_by_site_and_identifier_and_active(site, resp_get_info['id'], true)
					@connection.token = resp['access_token']
					@connection.data = resp_get_info.to_json
					@connection.name = resp_get_info['name']
				end
				@connection.save
			end
		when 'comm'
			is_verify = OpenSSL::PKey::RSA.new(config['public_key']).verify(OpenSSL::Digest::MD5.new, comm_hex2byte(params[:sign]), params[:plaintext])
			if is_verify &&!(plaintext = JSON.parse(params[:plaintext])).blank? && !plaintext['memberId'].blank? && plaintext['tpi'] == config['tpi']
				@connection = Core::Connection.find_or_initialize_by_site_and_identifier_and_active(site, plaintext['memberId'], true)
				@connection.name = '交通银行用户'
				@connection.data = params[:plaintext]
				@connection.save
			end
		when 'qq'
			options = { :grant_type => 'authorization_code', :client_id => config['key'], :client_secret => config['secret'], :code => params[:code], :redirect_uri => params[:state] }
			token_url = "#{config['site']}#{config['request_token_path']}?#{options.map{|k,v| "#{k}=#{CGI::escape(v)}"}.join('&')}"
			resp_token = HTTParty.get(token_url).body.split("&").map{|str| str.split("=") }.map{|k,v| {k => v}}.inject(&:merge)
			resp_openid = JSON.parse(HTTParty.get("#{config['site']}#{config['access_token_path']}?access_token=#{resp_token['access_token']}").body.match(/\{.*\}/).to_s)
			@connection = Core::Connection.find_or_initialize_by_site_and_identifier_and_active('qq', resp_openid['openid'], true)
			@connection.token = resp_token['access_token']
			resp_user_info = JSON.parse(HTTParty.get("https://graph.qq.com/user/get_user_info?access_token=#{resp_token['access_token']}&oauth_consumer_key=#{config['key']}&openid=#{resp_openid['openid']}").body)
			@connection.data = resp_user_info.to_json
			@connection.name = resp_user_info['nickname']
			@connection.sex = (resp_user_info['gender'] == '男') ? 'male' : 'female'
			@connection.save
		when 'qqcb'
			raw_string = params.slice(:Acct,:Attach,:OpenId, :LoginFrom, :ClubInfo, :ViewInfo, :Url, :Ts).sort.map{|m| m[1]}.join
			if params[:Vkey] ==  Digest::MD5.hexdigest(Digest::MD5.hexdigest(raw_string + config['key1']) + config['key2'])
				@connection = Core::Connection.find_or_initialize_by_site_and_identifier_and_active('qq', params[:Acct], true)
				view_info = CGI::unescapeHTML(CGI::unescape(params[:ViewInfo]))
				@connection.name = view_info.gsub('&nbsp;',' ').split("&").find{|f| f.match(/NickName=/) }.split("=").last
				@connection.data = view_info
				@connection.save
			end
		when 'wechat'
			redirect_to(redirect.present? && redirect || '/') and return unless params[:code].present?

			options = {
				appid: PAYMENT_CONFIG[site]['appid'],
				secret: PAYMENT_CONFIG[site]['secret'],
				code: params[:code].to_s,
				grant_type: 'authorization_code',
			}

			access_token_params = JSON.parse Timeout::timeout(30){ HTTParty.get("#{config['access_token_path']}?#{options.map{|k, v|"#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join('&')}").body }
			puts "eeeeeeeee#{access_token_params['errcode']}"
      redirect_to(redirect.present? && redirect || '/') and return if access_token_params['errcode'].present?

      # 改动3，根据 params[:type] 的值，分为 只取open_id 和 用户授权 两种情况。后者需要保存 connection，前者则只需跳转页面即可。
      if params[:scope].to_s == 'snsapi_base' && params[:type].to_s == 'binding'
        redirect_to(redirect.present? && push_param(redirect, "open_id=#{access_token_params['openid']}") || '/') and return
      end

			user_info_options = access_token_params.slice('access_token', 'openid').merge(lang: 'zh_CN')
			resp_user_info = JSON.parse Timeout::timeout(30){ HTTParty.get("#{config['user_info_path']}?#{user_info_options.map{|k, v|"#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join('&')}").body }
      redirect_to(redirect.present? && redirect || '/') and return if resp_user_info['errcode'].present?

      @connection = Core::Connection.where(site: site,identifier: resp_user_info['openid'].to_s, active: true).first_or_initialize
			@connection.attributes = {
				token: access_token_params['access_token'].to_s,
				refresh_token: access_token_params['refresh_token'].to_s,
				expired_at: Time.now + access_token_params['expires_in'].to_i,
				data: resp_user_info.to_json,
				name: resp_user_info['nickname'].to_s,
				pic: resp_user_info['headimgurl'].to_s,
				sex: { '0' => nil, '1' => 'male', '2' => 'female' }[resp_user_info['sex'].to_s],
			}
			@connection.save!
    end

		session[:connection_id] = @connection && @connection.id
		@connection = create_account(site) unless params[:type].to_s == 'binding'

		redirect_to site == 'alipay' && !params[:target_url].blank? && params[:target_url] || site == 'qqcb' && !params[:Url].blank? && params[:Url] || !redirect.blank? && redirect || '/'
	end

	##
	# == 调用连接网站接口
	#
	# === Request
	#
	# ==== Resource
	#
	# POST /connections/:id/api
	#
	# ==== Parameters
	#
	# id :: 连接ID
	# site :: 连接网站
	# url :: 接口地址
	# method :: HTTP方式
	# parameters :: 参数字符串
	#
	# === Response
	#
	# live :: \http://msdn.microsoft.com/en-us/library/ff748607.aspx
	# sina :: \http://open.t.sina.com.cn/wiki/index.php/API%E6%96%87%E6%A1%A3
	# douban :: \http://www.douban.com/service/apidoc/reference/
	#
	def api
		@connection = Core::Connection.find(params[:id])

		case params[:site]
		when 'live'

		when 'sina'

		when 'douban'
			@access_token = OAuth::AccessToken.new(OAuth::Consumer.new(config['key'], config['secret'], {
				:site               => 'http://api.douban.com',
				:signature_method   => 'HMAC-SHA1',
				:scheme             => :header,
				:http_method        => :post,
				:realm              => "http://#{HOSTS['dynamic']}",
			}), @connection.token, @connection.secret)

			resp = @access_token.send(params[:method], params[:url]).body if %w[get post put delete].include?(params[:method])
		end

		render :text => resp if resp
	end

	##
	# == 当前用户连接列表
	#
	# === Request
	#
	# ==== Resource
	#
	# GET /connections
	#
	# ==== Parameters
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <connections type="array">
	#       <connection>
	#         <id type="integer">ID</id>
	#         <account_id type="integer">帐号ID</account_id>
	#         <site>网站</site>
	#         <email>邮箱</email>
	#         <name>名字</name>
	#         <sex>性别</sex>
	#         <pic>头像</pic>
	#         <created_at type="datetime">创建时间</created_at>
	#         <updated_at type="datetime">更新时间</updated_at>
	#       </connection>
	#     </connections>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "connections" : [
	#       {
	#         "id" : ID,
	#         "account_id" : 帐号ID,
	#         "site" : 网站,
	#         "email" : 邮箱,
	#         "name" : 名字,
	#         "sex" : 性别,
	#         "pic" : 头像,
	#         "created_at" : 创建时间,
	#         "updated_at" : 更新时间,
	#       }
	#     ]
	#   }
	#
	def index
		unless @current_user
			not_authorized
			return
		end

		@connections = @current_user.account.connections

		respond_to do |format|
			format.html
			format.xml { @data = { 'connections' => @connections } }
		end
	end

	##
	# == 查看
	#
	# === Request
	#
	# ==== Resource
	#
	# GET /connections/:id
	#
	# ==== Parameters
	#
	# id :: 连接ID
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <connection>
	#       <id type="integer">ID</id>
	#       <account_id type="integer">帐号ID</account_id>
	#       <site>网站</site>
	#       <email>邮箱</email>
	#       <name>名字</name>
	#       <sex>性别</sex>
	#       <pic>头像</pic>
	#       <created_at type="datetime">创建时间</created_at>
	#       <updated_at type="datetime">更新时间</updated_at>
	#     </connection>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "connection" : {
	#       "id" : ID,
	#       "account_id" : 帐号ID,
	#       "site" : 网站,
	#       "email" : 邮箱,
	#       "name" : 名字,
	#       "sex" : 性别,
	#       "pic" : 头像,
	#       "created_at" : 创建时间,
	#       "updated_at" : 更新时间,
	#     }
	#   }
	#
	def show
		@connection = Core::Connection.acquire(params[:id])

		if !@connection || (session[:connection_id] != @connection.id && (!@current_user || @connection.account_id != @current_user.id))
			not_authorized
			return
		end

		respond_to do |format|
			format.html
			format.xml { @data = { 'connection' => @connection } }
		end
	end

	##
	# == 查看当前连接
	#
	# === Request
	#
	# ==== Resource
	#
	# GET /connections/current
	#
	# ==== Parameters
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <connection>
	#       <id type="integer">ID</id>
	#       <account_id type="integer">帐号ID</account_id>
	#       <site>网站</site>
	#       <email>邮箱</email>
	#       <name>名字</name>
	#       <sex>性别</sex>
	#       <pic>头像</pic>
	#       <created_at type="datetime">创建时间</created_at>
	#       <updated_at type="datetime">更新时间</updated_at>
	#     </connection>
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "connection" : {
	#       "id" : ID,
	#       "account_id" : 帐号ID,
	#       "site" : 网站,
	#       "email" : 邮箱,
	#       "name" : 名字,
	#       "sex" : 性别,
	#       "pic" : 头像,
	#       "created_at" : 创建时间,
	#       "updated_at" : 更新时间,
	#     }
	#   }
	#
	def current
		@connection = Core::Connection.acquire(session[:connection_id]) if session[:connection_id]

		respond_to do |format|
			format.html
			format.xml { @data = { 'connection' => @connection } }
		end
	end

	def edit # :nodoc:
		@connection = Core::Connection.acquire(params[:id])

		if !@connection || (session[:connection_id] != @connection.id && (!@current_user || @connection.account_id != @current_user.id))
			not_authorized
			return
		end
	end

	##
	# == 关联当前连接
	#
	# === Request
	#
	# ==== Resource
	#
	# PUT /connections/:id
	#
	# ==== Parameters
	#
	# id :: 连接ID
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <connection>
	#       <id type="integer">ID</id>
	#       <account_id type="integer">帐号ID</account_id>
	#       <site>网站</site>
	#       <email>邮箱</email>
	#       <name>名字</name>
	#       <sex>性别</sex>
	#       <pic>头像</pic>
	#       <created_at type="datetime">创建时间</created_at>
	#       <updated_at type="datetime">更新时间</updated_at>
	#     </connection>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "connection" : {
	#       "id" : ID,
	#       "account_id" : 帐号ID,
	#       "site" : 网站,
	#       "email" : 邮箱,
	#       "name" : 名字,
	#       "sex" : 性别,
	#       "pic" : 头像,
	#       "created_at" : 创建时间,
	#       "updated_at" : 更新时间,
	#     }
	#   }
	#
	def update
		@connection = Core::Connection.acquire(params[:id])

		if session[:connection_id] != @connection.id || @current_user.nil?
			not_authorized
			return
		end

		@connection.attributes = { :account_id => @current_user.id }

		if @connection.save
			session[:connection_id] = nil

			respond_to do |format|
				format.html { redirect_to request.referer || "/" }
				format.xml { @data = { 'connection' => @connection } }
			end
		else
			respond_to do |format|
				format.html { redirect_to request.referer || "/" }
				format.xml { ActiveRecord::RecordInvalid.new(@connection) }
			end
		end
	end

	##
	# == 解除连接
	#
	# === Request
	#
	# ==== Resource
	#
	# PUT /connections/:id
	#
	# === Parameters
	#
	# id :: 连接ID
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#   }
	#
	def destroy
		@connection = Core::Connection.acquire(params[:id])

		if @current_user.nil? || @current_user.id != @connection.account_id
			not_authorized
			return
		end

		@connection.update_attribute :account_id, nil

		respond_to do |format|
			format.html { redirect_to :action => 'index' }
			format.xml
		end
	end

	def popup
		render :layout => false
	end

	##
	# == 检验支付宝钱包token并返回一个connection
	#
	# === Request
	#
	# ==== Resource
	#
	# POST /connections/alipay_wallet
	#
	# ==== Parameters
	# user_id :: 移动端支付宝钱包返回的userid
	# token :: 移动端支付宝钱包返回的token
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <connection>
	#       <id type="integer">ID</id>
	#       <account_id type="integer">帐号ID</account_id>
	#       <site>网站</site>
	#       <email>邮箱</email>
	#       <name>名字</name>
	#       <sex>性别</sex>
	#       <pic>头像</pic>
	#       <created_at type="datetime">创建时间</created_at>
	#       <updated_at type="datetime">更新时间</updated_at>
	#     </connection>
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "connection" : {
	#       "id" : ID,
	#       "account_id" : 帐号ID,
	#       "site" : 网站,
	#       "email" : 邮箱,
	#       "name" : 名字,
	#       "sex" : 性别,
	#       "pic" : 头像,
	#       "created_at" : 创建时间,
	#       "updated_at" : 更新时间,
	#     }
	#   }
	#
	def alipay_wallet
		@cunnection = initialize_alipay_wallet_connection(params[:token].to_s, params[:user_id].to_s)

		respond_to do |format|
			format.xml { @data = { 'connection' => @connection } }
		end
	end

	private

	def create_account(site)
		database_transaction do
			unless @current_user
				unless @connection.account_id
					@account = Core::Account.new(:ip_address => request.remote_ip, :link_id => cookies[:link_id], :click_id => cookies[:click_id])
					@account.make_phone_activation_code
					@account.make_activation_code
					@account.save!
					@user = Core::User.new
					@user.id = @account.id
					@user.update_attributes!(:name => @connection.name)
					@info = Core::Info.new
					@info.id = @account.id
					@info.save!
					@setting = Core::Setting.new
					@setting.id = @account.id
					@setting.update_attributes!(:search_engine_indexing => true)
					@connection.update_attributes!(:account_id => @account.id)
				end
				self.current_account = @connection.account
				set_cookie(:remember_me, '1')
				set_cookie(:site, 'qq') if site == 'qq'
			end
		end
		@connection
	end

	def initialize_alipay_wallet_connection(token, user_id)
		@current_user = nil
		@connection = Core::Connection.find_or_initialize_by_site_and_identifier_and_active('alipay', params[:user_id].to_s, true)
		if @connection.new_record? || @connection.account.blank?
			database_transaction do
				options = {
					'service' => 'mobile.common.login.userInfo.query',
					'partner' => PAYMENT_CONFIG['alipay']['account'],
					'_input_charset' => 'UTF-8',
					'timestamp' => Time.now.to_s(:db),
					'token' => token,
				}
				options.merge!({
					'sign_type' => 'MD5',
					'sign' => Digest::MD5.hexdigest(options.sort.map{|k,v|"#{k}=#{v}"}.join("&")+PAYMENT_CONFIG['alipay']['key']),
				})
				doc = Nokogiri::XML::Document.parse(Timeout::timeout(10){HTTParty.get("https://mapi.alipay.com/gateway.do?#{options.sort.map{|k, v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" }.join('&')}").body})
				is_verify = doc.xpath('alipay/is_success').text.to_s == 'T' && Digest::MD5.hexdigest(doc.xpath('alipay/response/user_info').children.map{|child| {child.name.to_s => child.text.to_s}}.inject(&:merge).to_h.sort.map{|k,v| "#{k}=#{v}"}.join('&')+PAYMENT_CONFIG['alipay']['key']) == doc.xpath('alipay/sign').text.to_s && doc.xpath('alipay/response/user_info/user_id').text.to_s == user_id.to_s
				if is_verify
					name = doc.xpath('alipay/response/user_info/user_name').text.to_s
					name = '支付宝用户' if name.blank?
					logon_id = doc.xpath('alipay/response/user_info/logon_id').text.to_s
					phone = logon_id.match(/^\d+$/) ? logon_id : nil
					email = phone.blank? ? logon_id : nil
					attributes = {
						token: params[:token].to_s,
						data: Hash.from_xml(doc.to_xml).to_json,
						name: name,
						email: email,
						phone: phone,
					}
					@connection.attributes = attributes.select{ |k,v| v.present? }
					@connection.save
					@connection = create_account('alipay_wallet')
				end
			end
		elsif @current_account != @connection.account
			logout_killing_session!
			self.current_account = @connection.account
		end
		session[:connection_id] = @connection.try(:id)
		@connection
	end

	def comm_hex2byte(str)
		b, b2 = [], str.split(//)
		(b2.length-1).downto(0) do |i|
			next if i%2 != 0
			b[i/2] = (b2[i].to_s + b2[i+1].to_s).to_i(16)
		end
		b.pack("c*")
	end

	def authorized?
		true
	end

  # 组装个参数进去
  def push_param(url, param_str)
    arr = url.split('?')
    arr[0] + '?' + ( (arr[1] && arr[1].split('&').push(param_str).join('&')) || param_str )
  end
end
