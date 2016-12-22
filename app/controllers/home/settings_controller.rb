# 设置
#
class Home::SettingsController < Home::ApplicationController # :nodoc: all
	layout 'purple/application'

	def index
		@user = @viewer = @current_user
		@info = @user.info
		@setting ||= @current_user.setting
		@user_colleges_json = @user.college_affiliations.to_json(:only => [:id, :started_at, :ended_at, :position, :profession, :college_id])
		@user_companies_json  = @user.network_affiliations.to_json(:only => [:id, :started_at, :ended_at, :position, :profession, :network_id], :include => {:network => {:only => [:id, :name, :type]}})
	end

	# == Function
	#
	# 查看隐私设置
	#
	# == Route
	#
	# GET /settings/privacy
	#
	# == Response
	#
	# 返回一条Core::Setting
	#
	#
	# === XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <setting><id type="integer">1</id>...</setting>
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "setting": { "id": 1, ... },
	#   }
	#
	def privacy # :nodoc:

		@setting ||= @current_user.setting

		respond_to do |format|
			format.html
			format.xml { @data = { 'setting' => @setting } }
			format.js  { render :text => '' }
		end
	end

	# == Function
	#
	# 查看通知设置
	#
	# == Route
	#
	# GET /settings/notifications
	#
	# == Response
	#
	# 返回一条Core::Setting
	#
	#
	# === XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <setting><id type="integer">1</id>...</setting>
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "setting": { "id": 1, ... },
	#   }
	#
	def notifications # :nodoc:

		@setting ||= @current_user.setting

		respond_to do |format|
			format.html
			format.xml { @data = { 'setting' => @setting } }
			format.js { render :text => '' }
		end
	end

	def designating # :nodoc:
		respond_to do |format|
			format.html {  render :layout => false }
		end
	end

	# == Function
	#
	# 查找用户名
	#
	# == Route
	#
	# GET /settings/find_user_name
	#
	# == Parameters
	#
	# name :: 用户名首位或用户名
	#
	# == Response
	#
	# 返回多个id, name键值对
	#
	# === XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <users>
	#       <user>
	#         <id>1</id>
	#         <name>'cc'</name>
	#       </user>
	#       <user>
	#         <id>1</id>
	#         <name>'cc'</name>
	#       </user>
	#     </users>
	#     .....
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "users": [
	#       { "id": 1,"name": "cd" },
	#       { "id": 2,"name": "cu" },
	#       .....
	#     ]
	#   }
	#
	def find_user_name # :nodoc:
		name = params[:name].to_s.strip
		@names = if name.blank?
			# 无输入时，返回全部
			chinese_match
		elsif ('a'..'z').to_a.index name.chars.first.downcase
			#拼音匹配
			chinese_match # 给@friends赋值
			hash = {}
			@friends.select {|u| %w(, ,).join(u.abbrs).index %w(, ,).join(name) }.map {|u| hash[u.id] = { 'name' => u.name, 'pic' => u.pic_q } }
			hash
		else
			# 中文匹配
			chinese_match.select {|id, values| values['name'] =~ /#{name}/}.to_hash
		end

		respond_to do |format|
			format.js { render :text => @names.to_json }
		end
	end

	# == Function
	#
	# 查找公司名
	#
	# == Route
	#
	# POST /settings/find_company_name
	#
	# == Parameters
	#
	# name :: 公司名
	#
	# == Response
	#
	# 返回多个Core::Network
	#
	# === XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <companies>
	#       <company><id>1</id><name>浦发银行</name>...</company>
	#       <company><id>2</id><name>招商银行</name>...</company>
	#       ....
	#     </companies>
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "companies": [
	#     { "id": 1,"name": "浦发银行", ... },
	#     { "id": 2,"name": "招商银行", ... },
	#      .....
	#     ]
	#   }
	#
	def find_company_name # :nodoc:
		results = []
		# TS的boolean, any搜索模式下对中英文均无效, 暂时折衷为and模式
		# 换用官方sphinx后无此问题
		if is_sphinx_enabled?
			(IHaveU::Search.chinese_words params[:name]).each {|word|
				results += Core::Network.search(word).map {|n| {:id => n.id, :name => n.name} }
			}
		else
			results = Core::Network.find(:all,:conditions=> ['name like ?','%'+params[:name]+'%']).map{|r| {:id => r.id, :name => r.name}}
		end if params[:name]

		respond_to do |format|
			format.xml { @data = {'users' => kv_to_xml(results.uniq) } }
			format.js { render :text => results.uniq.to_xml }
		end
	end

	# == Function
	#
	# 查找用户名和id
	#
	# == Route
	#
	# POST /settings/return_name_of_id
	#
	# == Parameters
	#
	# ids :: 用户id,用','隔开
	#
	# == Response
	#
	# 返回多个Core::User
	#
	# === XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <users>
	#       <user>
	#         <name>hunk</name>
	#         <id>6</id>
	#       </user>
	#       <user>
	#         <name>mvj3</name>
	#         <id>7</id>
	#       </user>
	#     </users>
	#     .....
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "users": [
	#       { "id": 6,"name": "hunk" },
	#       { "id": 7,"name": "mvj3"}
	#       .....
	#     ]
	#   }
	#
	def return_name_of_id # :nodoc:

		users = Core::User.find(params[:ids].split(","))
		ids =  users.map{ |u| {:id => u.id , :name => u.name} }

		respond_to do |format|
			format.xml { @data = {'users' => kv_to_xml(ids) } }
			format.js { render :text => ids.to_json }
		end
	end

	# == Function
	#
	# 修改隐私设置
	#
	# == Route
	#
	# PUT /settings/:id
	#
	# == Parameters
	#
	# id :: 用户ID
	# settings[profile] :: 积分累计
	# settings[friend] :: 相对积分
	# settings[feed] :: 新鲜事
	# settings[basic] :: 基本信息
	# settings[personal] :: 个人信息
	# settings[work] :: 工作信息
	# settings[im] :: MSN
	# settings[mobile] :: 手机
	# settings[phone] :: 电话
	# settings[website] :: 网站
	# settings[email] :: 邮件
	# settings[search] :: 搜索
	#
	# == Response
	#
	# 返回修改成功的Core::Setting
	#
	# === XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <setting><id type="integer">1</id>...</setting>
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "setting": { "id": 1, ... },
	#   }
	#
	def update
		@setting = @current_user.setting
		params[:setting].each { |column,value|  @setting.update_attributes(column=>value) }

		if @setting.errors.empty?
			@setting.updated
			respond_to do |format|
				format.html { redirect_to request.referrer || setting_index_path }
				format.xml { @data = {'setting' => @setting } }
				format.js { render :text => '' }
			end
		else
			respond_to do |format|
				format.html { render :action => 'show', :id => params[:id] }
				format.xml
				format.js { render :text => '' }
			end
		end
	end

	private

	def chinese_match
		@friends = @current_user.friends
		h = {}
		@friends.map{ |u| h[u.id] = {}; h[u.id]['name'] = u.name; h[u.id]['pic'] = ( u.pic ? (u.pic << '.n.jpg') : (u.female? ? 'images/shared/female_n.gif' : 'images/shared/male_n.gif') ) }
		h
	end

	def kv_to_xml(array)
		array.map {|x| {'id' => x.keys[0], 'name' => x.values[0]}}
	end
end
