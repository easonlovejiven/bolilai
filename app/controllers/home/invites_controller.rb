##
# = 主站 邀请 界面
#
class Home::InvitesController < Home::ApplicationController

	##
	# == 剩余邀请数
	#
	# === Request
	#
	# ==== Resource
	#
	# GET /invites/count
	#
	# ==== Parameters
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <invitations_count>已邀请个数</invitations_count>
	#     <available_invitations_count>可用邀请个数</available_invitations_count>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "invitations_count" : 已邀请个数,
	#     "available_invitations_count" : 可用邀请个数,
	#   }
	#
	def count
		respond_to do |format|
			format.xml { @data = { 'available_invitations_count' => @current_user.available_invitations_count, 'invitations_count' => @current_user.invitations.count } }
		end
	end

	##
	# == 列表
	#
	# === Request
	#
	# ==== Resource
	#
	# GET /invites
	#
	# ==== Parameters
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <invitations type="array">
	#       <invitation type="Core::Invitation">
	#         <id type="integer">ID</id>
	#         <user_id type="integer">用户ID</user_id>
	#         <email>邮件</email>
	#         <invitee_id type="integer">被邀请ID</invitee_id>
	#         <created_at type="datetime">创建时间</created_at>
	#         <updated_at type="datetime">更新时间</updated_at>
	#         <invitee>
	#           <id type="integer">ID</id>
	#           <pic>头像</pic>
	#           <name>名字</name>
	#           <sex>性别</sex>
	#         </initee>
	#       </invitation>
	#     </invitations>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "invitations" : [
	#       {
	#         "id" : ID,
	#         "user_id" : 用户ID,
	#         "email" : 邮件,
	#         "invitee_id" : 被邀请ID,
	#         "created_at" : 创建时间,
	#         "updated_at" : 更新时间,
	#         "invitee" : {
	#           "id" : ID,
	#           "pic" : 头像,
	#           "name" : 名字,
	#           "sex" : 性别,
	#         },
	#       },
	#     ],
	#   }
	#
	def index
		@invitations = @current_user.invitations

		respond_to do |format|
			format.html
			format.xml { @data = { 'invitations' => @invitations } }
			format.js { render :text => "" }
		end
	end

	##
	# == 查找联系人
	#
	# === Request
	#
	# ==== Resource
	#
	# POST /invites/find
	#
	# ==== Parameters
	#
	# 选择以下三者其一
	#
	# email :: 邮箱 *
	# password :: 密码 *
	# type :: 指定为取MSN联系人的时候为msn
	#
	# emails :: 多个被邀请的好友email地址列表
	#
	# file :: 联系人文件
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <users type="array">
	#       <user>
	#         <id type="integer">ID</id>
	#         <pic>头像</pic>
	#         <name>名字</name>
	#         <sex>性别</sex>
	#       </user>
	#     </users>
	#     <accounts>
	#       <account>
	#         <email>邮件地址</email>
	#       </account>
	#     </accounts>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "users": [
	#       {
	#         "id" : ID,
	#         "pic" : 头像,
	#         "name" : 名字,
	#         "sex" : 性别,
	#       }
	#     ],
	#     "accounts": [
	#       {
	#         'email' : 邮件地址,
	#       }
	#     ]
	#   }
	#
	def find
		_emails = if params[:email] # 邮箱或msn导入
			begin
				type = ( domain = params[:email].split("@")[1] ).include?("vip") ? 'vip' : domain.split('.').first
				contacts = ContactList::Client.fetch(params[:email], params[:password], (params[:type] || type))
				contacts.map{ |c| { :address => c.email, :name => c.username } }
			rescue ContactList::ContactListException
			end
		elsif params[:emails] || params[:file] # 直接输入多个email 联系人文件
			extract_emails_from_text(params[:file] ? params[:file].read : params[:emails]).map {|e| { :address => e, :name => e.split('@')[0] } }
		end

		@users, @emails = [], []
		_emails.each do |email|
			if account = Core::Account.find_by_email(email[:address])
				@users << account.user if account.user != @current_user && !Core::Friendship.find_by_user_id_and_relate_id(@current_user.id, account.user.id)
			else
				@emails << email[:address]
			end
		end if _emails.is_a? Array

		if params[:redirect]
			flash[:data] = { :users => @users, :emails => @emails }
			respond_to do |format|
				format.html { redirect_to params[:redirect] }
				format.xml { @data = { 'users' => @users.assign_options(:only => [:id, :name, :sex, :pic]), 'emails' => @emails } }
			end
		end

		respond_to do |format|
			format.html
			format.xml { @data = { 'users' => @users.assign_options(:only => [:id, :name, :sex, :pic]), 'accounts' => @emails.map {|email| Core::Account.new( :email => email ) }.assign_options( :only => :email ) } }
		end

	end

	##
	# == 添加邀请人
	#
	# === Request
	#
	# ==== Resource
	#
	# POST /invites
	#
	# ==== Parameters
	#
	# \emails[] :: 邮箱数组
	# \users[][id] :: 用户ID数组
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <invitations type="array">
	#       <invitation type="Core::Invitation">
	#         <id type="integer">ID</id>
	#         <user_id type="integer">用户ID</user_id>
	#         <email>邮件</email>
	#         <invitee_id type="integer">被邀请ID</invitee_id>
	#         <created_at type="datetime">创建时间</created_at>
	#         <updated_at type="datetime">更新时间</updated_at>
	#         <invitee>
	#           <id type="integer">ID</id>
	#           <pic>头像</pic>
	#           <name>名字</name>
	#           <sex>性别</sex>
	#         </initee>
	#       </invitation>
	#     </invitations>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "invitations" : [
	#       {
	#         "id" : ID,
	#         "user_id" : 用户ID,
	#         "email" : 邮件,
	#         "invitee_id" : 被邀请ID,
	#         "created_at" : 创建时间,
	#         "updated_at" : 更新时间,
	#         "invitee" : {
	#           "id" : ID,
	#           "pic" : 头像,
	#           "name" : 名字,
	#           "sex" : 性别,
	#         },
	#       },
	#     ],
	#   }
	#
	def create
		params[:emails] = params[:emails].values if params[:emails].is_a? Hash
		params[:emails] ||= []

		# if params[:emails].size > @current_user.available_invitations_count
		# 	not_authorized
		# 	return
		# end

		@invitations = params[:emails].map do |email|
			invitation = @current_user.invitation_of(email)

			Core::Mailer.mail(
				:recipients => invitation.email,
				:subject => "#{@current_user.name} 邀请您加入珀丽莱",
				:template => 'invite',
				:body => { :invitation => invitation, :user => @current_user }
			)
			invitation
		end

		params[:users] = params[:users].values if params[:users].is_a? Hash

		(params[:users]||[]).map{|u| Core::User.find(u[:id]) }.each do |user|
			Talk::FriendRequest.deliver(
				:user => Talk::User.acquire(@current_user.id),
				:receiver => Talk::User.acquire(user.id)
			)
			Talk::Notification.deliver(
				:receiver => user,
				#:content => "#{@current_user.name}希望成为您的好友"
				:content => "
亲爱的#{user.name}，您好：
　　#{@current_user.name}申请成为您的好友，请及时查看。
"
			) if user.setting.adds_a_friend_i_suggested?
		end

		respond_to do |format|
			format.html { redirect_to params[:redirect] if params[:redirect] }
			format.xml { @data = { 'invitations' => @invitations } }
		end
	end

	private
	def extract_emails_from_text(text) # :nodoc:
		text.to_s.scan(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i).uniq
	end

	def extract_nums_from_text(text) # :nodoc:
		text.to_s.scan(/\d/).uniq
	end
end
