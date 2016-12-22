# 状态
#
class Home::StatusController < Home::ApplicationController # :nodoc: all
	layout 'main/application'

	# == Function
	#
	# 显示分享列表
	#
	# == Route
	#
	# GET /status
	#
	# == Parameters
	#
	# user_id :: 用户id，无指定则为自己好友的状态
	# page :: 页数，默认为1
	# per_page :: 每页个数
	#
	# == Response
	#
	# 返回多个Core::Feed
	#
	# === XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <feeds type="array">
	#       <feed>
	#         <id type="integer">ID</id>
	#         <content>内容</content>
	#         <geolocation nil="true">地理信息</geolocation>
	#         <links>链接</links>
	#         <attachment>附件</attachment>
	#         <privacy>隐私</privacy>
	#         <created_at type="datetime">创建时间</created_at>
	#         <updated_at type="datetime">更新时间</updated_at>
	#         <source_id type="integer">来源ID</id>
	#         <actor_id type="integer">行为者ID</id>
	#         <target_id type="integer">目标ID</id>
	#         <source>
	#           <id type="integer">ID</id>
	#           <name>名字</name>
	#           <pic>图片URL</pic>
	#           <sex>性别</sex>
	#         </source>
	#         <actor>
	#           <id type="integer">ID</id>
	#           <name>名字</name>
	#           <pic>图片URL</pic>
	#           <sex>性别</sex>
	#         </actor>
	#         <target>
	#           <id type="integer">ID</id>
	#           <name>名字</name>
	#           <pic>图片URL</pic>
	#           <sex>性别</sex>
	#         </target>
	#       </feed>
	#     </feeds>
	#   </response>
	#
	# === JSON
	#
	#   {
	#     "feeds" : [
	#       {
	#         "id" : 'ID',
	#         "content" : "内容",
	#         "geolocation" : "地理信息",
	#         "links" : "链接",
	#         "attachment" : "附件",
	#         "privacy" : "隐私",
	#         "created_at" : '创建时间',
	#         "updated_at" : '更新时间',
	#         "source_id" : '来源ID',
	#         "actor_id" : '行为者ID',
	#         "target_id" : '目标ID',
	#         "source" : [
	#           "id" : "ID",
	#           "name" : "名字",
	#           "pic" : "图片URL",
	#           "sex" : "性别",
	#         ],
	#         "actor" : [
	#           "id" : "ID",
	#           "name" : "名字",
	#           "pic" : "图片URL",
	#           "sex" : "性别",
	#         ],
	#         "target" : [
	#           "id" : "ID",
	#           "name" : "名字",
	#           "pic" : "图片URL",
	#           "sex" : "性别",
	#         ]
	#       }
	#     ]
	#   }
	#
	# == Examples
	#
	# GET http://test.barlar.com/status.xml?sig=false
	#
	def index
		@user = params[:user_id] ? Core::User.find(params[:user_id]) : @current_user
		@feeds = if @user
			@user.streams.scoped(:conditions => ['app_id = ?', '2']).paginate(:per_page => 20, :page => params[:page])
		else
			ids = @user.friend_ids
			ids.empty? ? [] : Core::Stream.paginate(:page => params[:page], :per_page => 20, :conditions => "source_id IN (#{ids.join(',')}) AND app_id = 2", :total_entries => 20)
		end.map(&:feed)
		
		respond_to do |format|
			format.html
			format.xml { @data = { 'feeds' => @feeds } }
			format.js { @data = { 'user' => @user, 'statuses' => @statuses } } # TODO statuss改为statuses, html/js
		end
	end
	
end
