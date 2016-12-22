##
# = 主站 好友分组 界面
#
class Home::ListsController < Home::ApplicationController

	##
	# == 列表
	#
	# === Request
	#
	# ==== Resource
	#
	# GET /users/:user_id/lists
	#
	# ==== Parameters
	#
	# user_id :: 用户ID
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <lists type="array">
	#       <list>
	#         <id type="integer">ID</id>
	#         <user_id type="integer">用户ID</user_id>
	#         <name>名称</name>
	#         <friend_list type="text">朋友列表</friend_list>
	#         <created_at type="datetime">创建时间</created_at>
	#         <updated_at type="datetime">更新时间</updated_at>
	#         <is_default type="boolean">是否系统默认分组</is_default>
	#       </list>
	#     </lists>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "lists" : [
	#       {
	#         "id" : ID,
	#         "user_id" : 用户ID,
	#         "name" : 名称,
	#         "friend_list" : 朋友列表,
	#         "created_at" : 创建时间,
	#         "updated_at" : 更新时间,
	#         "is_default" :: 是否系统默认分组,
	#       }
	#     ]
	#   }
	#
	def index
		@lists = Core::User.acquire(params[:user_id]).grouped_lists

		respond_to do |format|
			format.html { redirect_to friends_path }
			format.xml { @data = { 'lists' => @lists } }
		end
	end

	##
	# == 查看
	#
	# === Request
	#
	# ==== Resource
	#
	# GET /users/:user_id/lists/:id
	#
	# ==== Parameters
	#
	# user_id :: 用户ID
	# id :: 组ID
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <list>
	#       <id type="integer">ID</id>
	#       <user_id type="integer">用户ID</user_id>
	#       <name>名称</name>
	#       <friend_list type="text">朋友列表</friend_list>
	#       <created_at type="datetime">创建时间</created_at>
	#       <updated_at type="datetime">更新时间</updated_at>
	#       <is_default type="boolean">是否系统默认分组</is_default>
	#       <users type="array">
	#         <user type="Core::User">
	#           <id type="integer">ID</id>
	#           <name>名字</name>
	#           <pic>头像</pic>
	#           <sex>性别</sex>
	#         </user>
	#       </users>
	#     </list>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "list" : {
	#       "id" : ID,
	#       "user_id" : 用户ID,
	#       "name" : 名称,
	#       "friend_list" : 朋友列表,
	#       "created_at" : 创建时间,
	#       "updated_at" : 更新时间,
	#       "is_default" :: 是否系统默认分组,
	#       "users" : [
	#         {
	#           "id" : ID,
	#           "name" : 名字,
	#           "pic" : 头像,
	#           "sex" : 性别,
	#         },
	#       ]
	#     }
	#   }
	#
	def show
		@list = Core::List.acquire(params[:id])
		@list.read(:user => @current_user)

		if @list.user != @current_user
			redirect_to friends_path
			return
		end

		ids = (@list.friend_list&&@list.friend_list.split(',').map(&:to_i) || []) & @current_user.friend_ids
		@friends = Core::User.find(ids)

		respond_to do |format|
			format.html { render :template => "home/friends/index" }
			format.js { render :text => '' }
			format.xml { @data = { 'list' => @list.assign_options(:except => [:active, :destroyed_at], :objects => { :users => { :only => [ :id, :name, :sex, :pic ] } }) } }
		end
	end

	def new # :nodoc: all
	 # @user = Core::User.find(params[:id])
		render :layout => false
	end

	def edit # :nodoc: all
		@list = Core::List.find(params[:id])

		respond_to do |format|
			format.html { render :layout => false }
			format.js { render :text => '' }
		end
	end

	##
	# == 创建
	#
	# === Request
	#
	# ==== Resource
	#
	# POST /users/:user_id/lists
	#
	# ==== Parameters
	#
	# user_id :: 用户ID
	# \list[name] :: 组名
	# \list[friend_list] :: 好友id,用','隔开
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <list>
	#       <id type="integer">ID</id>
	#       <user_id type="integer">用户ID</user_id>
	#       <name>名称</name>
	#       <friend_list type="text">朋友列表</friend_list>
	#       <created_at type="datetime">创建时间</created_at>
	#       <updated_at type="datetime">更新时间</updated_at>
	#       <is_default type="boolean">是否系统默认分组</is_default>
	#     </list>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "list" : {
	#       "id" : ID,
	#       "user_id" : 用户ID,
	#       "name" : 名称,
	#       "friend_list" : 朋友列表,
	#       "created_at" : 创建时间,
	#       "updated_at" : 更新时间,
	#       "is_default" :: 是否系统默认分组,
	#     }
	#   }
	#
	def create
		@list = Core::List.new
		@list.user_id = @current_user.id
		@list.name = params[:list][:name]
		@list.friend_list = process_ids params[:list][:friend_list]
		@list.is_default = false
		@list.save

		respond_to do |format|
			format.html { redirect_to list_path(@list) }
			format.js   { render :text => '' }
			format.xml { @data = { 'list' => @list } }
		end
	end

	##
	# == 编辑
	#
	# === Request
	#
	# ==== Resource
	#
	# PUT /users/:user_id/lists/:id
	#
	# ==== Parameters
	#
	# user_id :: 用户ID
	# id :: 组ID
	# \list[name] :: 组名
	# \list[friend_list] :: 好友id,用','隔开
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <list>
	#       <id type="integer">ID</id>
	#       <user_id type="integer">用户ID</user_id>
	#       <name>名称</name>
	#       <friend_list type="text">朋友列表</friend_list>
	#       <created_at type="datetime">创建时间</created_at>
	#       <updated_at type="datetime">更新时间</updated_at>
	#       <is_default type="boolean">是否系统默认分组</is_default>
	#     </list>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "list" : {
	#       "id" : ID,
	#       "user_id" : 用户ID,
	#       "name" : 名称,
	#       "friend_list" : 朋友列表,
	#       "created_at" : 创建时间,
	#       "updated_at" : 更新时间,
	#       "is_default" :: 是否系统默认分组,
	#     }
	#   }
	#
	def update
		@list = Core::List.acquire(params[:id])
		@list.name = params[:list][:name] if params[:list][:name]
		@list.friend_list = process_ids params[:list][:friend_list]
		if @list.changed?
			@list.save
			@list.updated
		end

		respond_to do |format|
			format.html { redirect_to list_path(@list) }
			format.xml { @data = { 'list' => @list } }
			format.js { render :text => '' }
		end
	end

	##
	# == 删除
	#
	# === Request
	#
	# ==== Resource
	#
	# DELETE /users/:user_id/lists/:id
	#
	# ==== Parameters
	#
	# user_id :: 用户ID
	# id :: 组ID
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
		@list = Core::List.acquire(params[:id])
		@list.destroy_softly if @list.user_id == @current_user.id

		respond_to do |format|
			format.html { redirect_to friends_path }
			format.js   { render :text => '' }
			format.xml
		end
	end

	private
	def process_ids(ids)
		ids.to_s.split(',').map(&:to_i).reject {|n| n.zero? }.select {|n| @current_user.friend_ids.include? n }.join(',')
	end

end
