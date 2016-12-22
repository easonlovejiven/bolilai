##
# = 主站 最近来访 界面
#
class Home::VisitsController < Home::ApplicationController

	##
	# == 列表
	#
	# === Request
	#
	# ==== Resource
	#
	# GET /visits
	#
	# ==== Parameters
	#
	# page :: 页数
	# per_page :: 每页个数
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <visits>
	#       <visit>
	#         <id>ID</id>
	#         <pic>头像</pic>
	#         <name>名字</name>
	#         <sex>性别</sex>
	#         <info>
	#           <point>积分</point>
	#         </info>
	#       </visit>
	#     </visits>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "visits" : [
	#       {
	#         "id" : ID,
	#         "pic" : 头像,
	#         "name" : 名字,
	#         "sex" : 性别,
	#         "info" : {
	#           "point" : 积分,
	#         }
	#       }
	#     ]
	#   }
	#
	def index
		@visits = @current_user.visitors._order(:created_at => 'DESC').paginate(:page => params[:page], :per_page => params[:per_page] || 10)

		respond_to do |format|
			format.xml { xo = Core::User.xml_options.deep_clone; xo[:include] = { :info => { :only => [:point] } }; xo[:only].delete(:birthday); @data = { 'visits' => @visits.assign_options(xo) }  }
		end
	end

	##
	# == 创建
	#
	# === Request
	#
	# ==== Resource
	#
	# POST /visits
	#
	# ==== Parameters
	#
	# user_id :: 被访问用户ID
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
	def create
		if ( @viewed_user = Core::User.find(params[:user_id]) ).allow?(@current_user, 'profile')
			@viewed_user.visited_by(@current_user)
		end

		respond_to do |format|
			format.xml
		end
	end
end
