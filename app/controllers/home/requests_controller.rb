__END__
# 请求
#
class Home::RequestsController < Home::ApplicationController

	# == Function
	#
	# 显示邀请列表
	#
	# == Route
	#
	# GET /requests
	#
	# == Parameters
	#
	# page :: 页数，默认为1
	# per_page :: 每页个数
	#
	# == Response
	#
	# 返回多个好友Core::User
	#
	# === XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <invitations type="array">
	#       <invitation>
	#         <id type="integer">ID</id>
	#         <user_id type="integer">用户标识</user_id>
	#         <email>邮件</email>
	#         <app_id type="integer">应用标识</app_id>
	#         <invitee_id type="integer">被邀请标识</invitee_id>
	#         <created_at type="datetime">创建时间</created_at>
	#         <updated_at type="datetime">更新时间</updated_at>
	#         <code>邀请码</code>
	#       </invitation>
	#     </invitations>
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "invitations" : [
	#       {
	#         "id" : 'ID',
	#         "user_id" : '用户标识',
	#         "email" : '邮件',
	#         "app_id" : '应用标识',
	#         "invitee_id" : '被邀请标识',
	#         "created_at" : '创建时间',
	#         "updated_at" : '更新时间',
	#         "code" : '邀请码',
	#       }
	#     ]
	#   }
	#
	# == Examples
	#
	# GET http://test.barlar.com/requests.xml?sig=false
	#
	def index
		@invitations = @current_user.invitations.paginate(:per_page => params[:per_page] || 8, :page => params[:page])

		respond_to do |format|
			format.html
			format.xml { @data = { 'invitations' => @invitations } }
		end
	end

	# == Function
	#
	# 发送朋友请求
	#
	# == Route
	#
	# POST /requests
	#
	# == Parameters
	#
	# friendship[friend_id] :: 好友ID
	# friendship[content] :: 说句什么吧
	#
	# == Response
	#
	# 返回一个Core::Request
	#
	# === XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <request>
	#       <id type="integer">ID</id>
	#       <user_id type="integer">用户标识</user_id>
	#       <receiver_id type="integer">接受者标识</receiver_id>
	#       <object_id type="integer">多项标识</object_id>
	#       <type>类型</type>
	#       <accept type="boolean">接受</accept>
	#       <created_at type="datetime">创建时间</created_at>
	#       <updated_at type="datetime">更新时间</updated_at>
	#       <content type="text">内容</content>
	#     </request>
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "request" : {
	#       "id" : 'ID',
	#       "user_id" : '用户标识',
	#       "receiver_id" : '接受者标识',
	#       "object_id" : '多项标识',
	#       "type" : '类型',
	#       "accept" : '接受',
	#       "created_at" : '创建时间',
	#       "updated_at" : '更新时间',
	#       "content" : '内容',
	#     }
	#   }
	#
	def create
		@user = Core::User.find(params[:friendship][:friend_id])

		@request = Talk::FriendRequest.deliver(
			:user => @current_user,
			:receiver => @user,
			:content => params[:friendship][:content]
		)
		Core::Mailer.mail( # TODO 给一个邮箱只能发一次
			:recipients => @user.account.email,
			:subject => %[#{@current_user.name}想加你为Ihaveu朋友...],
			:template => 'friend_request',
			:body => { :user => @current_user, :friend => @user }
		)

		respond_to do |format|
			format.html { redirect_to request.referer || profile_path(@user) }
			format.xml { @data = { 'request' => @request } }
			format.js   { render :text => @user.to_json }
		end
	end

	# == Function
	#
	# 接受请求
	#
	# == Route
	#
	# PUT /requests/:id/accpet
	#
	# == Parameters
	#
	# id :: 请求id
	#
	# == Response
	#
	# 返回更改后的Core::Request
	#
	# === XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <request>
	#       <id type="integer">ID</id>
	#       <user_id type="integer">用户标识</user_id>
	#       <receiver_id type="integer">接受者标识</receiver_id>
	#       <object_id type="integer">多项标识</object_id>
	#       <type>类型</type>
	#       <accept type="boolean">接受</accept>
	#       <created_at type="datetime">创建时间</created_at>
	#       <updated_at type="datetime">更新时间</updated_at>
	#       <content type="text">内容</content>
	#     </request>
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "request" : {
	#       "id" : 'ID',
	#       "user_id" : '用户标识',
	#       "receiver_id" : '接受者标识',
	#       "object_id" : '多项标识',
	#       "type" : '类型',
	#       "accept" : '接受',
	#       "created_at" : '创建时间',
	#       "updated_at" : '更新时间',
	#       "content" : '内容',
	#     }
	#   }
	#
	def accept
		@request = Talk::FriendRequest.find(params[:id])
		if @request.receiver_id == @current_user.id && @request.accept!
			Core::Feed.publish(
				:app => HOME_APP,
				:content => %[和<a href="/profile/#{@request.user.id}">#{@request.user.name}</a>成为好友],
				:actor => @current_user
			) if @request.type == 'Talk::FriendRequest'
		end

		respond_to do |format|
			format.html { redirect_to requests_path }
			format.xml { @data = { 'request' => @request } }
			format.js  { render :text => @request.to_json }
		end

	end

	# == Function
	#
	# 拒绝请求
	#
	# == Route
	#
	# PUT /requests/:id/reject
	#
	# == Parameters
	#
	# id :: 请求id
	#
	# == Response
	#
	# 返回更改后的Core::Request
	#
	# === XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <request>
	#       <id type="integer">ID</id>
	#       <user_id type="integer">用户标识</user_id>
	#       <receiver_id type="integer">接受者标识</receiver_id>
	#       <object_id type="integer">多项标识</object_id>
	#       <type>类型</type>
	#       <accept type="boolean">接受</accept>
	#       <created_at type="datetime">创建时间</created_at>
	#       <updated_at type="datetime">更新时间</updated_at>
	#       <content type="text">内容</content>
	#     </request>
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "request" : {
	#       "id" : 'ID',
	#       "user_id" : '用户标识',
	#       "receiver_id" : '接受者标识',
	#       "object_id" : '多项标识',
	#       "type" : '类型',
	#       "accept" : '接受',
	#       "created_at" : '创建时间',
	#       "updated_at" : '更新时间',
	#       "content" : '内容',
	#     }
	#   }
	#
	def reject
		@request = Core::Request.find(params[:id])
		if @request.receiver_id == @current_user.id && @request.reject

		end
		respond_to do |format|
			format.html { redirect_to requests_path }
			format.xml { @data = { 'request' => @request } }
			format.js  { render :text => '' }
		end
	end

end
