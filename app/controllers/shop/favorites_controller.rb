##
# = 商城 收藏 界面
#
class Shop::FavoritesController < Shop::ApplicationController
	layout false

	##
	# == 列表
	#
	# === Request
	#
	# ==== Resource
	#
	# GET /auction/favorites
	#
	# ==== Parameters
	#
	# \where[product_id] :: 产品ID
	# page :: 页数
	# per_page :: 每页个数
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <favorites type="Array">
	#       <favorite type="Shop::Favorite">
	#         <id type="integer">ID</id>
	#         <product_id type="integer">产品ID</product_id>
	#         <updated_at type="datetime">更新时间</updated_at>
	#       </favorite>
	#     </favorites>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "favorites" : [
	#       {
	#         "id" : ID,
	#         "product_id" : 产品ID,
	#         "updated_at" : 更新时间,
	#       },
	#     ]
	#   }
	#
	def index
		@favorites = @current_user.favorites.active._where(params[:where])._order(params[:order] || { :updated_at => 'DESC' }).page(params[:page]).per(params[:per_page] || 10)

		respond_to do |format|
			format.html
			format.xml { @data = { 'favorites' => @favorites } }
		end
	end

	def show # :nodoc:
		@favorite = Shop::Favorite.acquire(params[:id])

		if @favorite.user_id != @current_user.id
			not_authorized
			return
		end

		respond_to do |format|
			format.html { render :layout => false if request.xhr? }
			format.xml  { render :xml => @favorite }
		end
	end

	def new # :nodoc:
		@favorite = Shop::Favorite.new

		respond_to do |format|
			format.html { render :layout => false if request.xhr? }
			format.xml  { render :xml => @favorite }
		end
	end

	##
	# == 创建
	#
	# === Request
	#
	# ==== Resource
	#
	# POST /auction/favorites
	#
	# ==== Parameters
	#
	# \favorite[product_id] :: 产品ID
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <favorite type="Shop::Favorite">
	#       <id type="integer">ID</id>
	#       <product_id type="integer">产品ID</product_id>
	#       <updated_at type="datetime">更新时间</updated_at>
	#     </favorite>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "favorites" : {
	#       "id" : ID,
	#       "product_id" : 产品ID,
	#       "updated_at" : 更新时间,
	#     },
	#   }
	#
	def create
		@favorite = Shop::Favorite.find_or_initialize_by(params.require(:favorite).permit([:product_id]).merge(user_id: @current_user.id, active: true))
		@favorite.updated_at = Time.now unless @favorite.new_record?

		if @favorite.save
			respond_to do |format|
				format.html { redirect_to auction_favorite_path(@favorite) }
				format.xml { @data = { 'favorite' => @favorite } }
			end
		else
			respond_to do |format|
				format.html { render :action => :new }
				format.xml { raise ActiveRecord::RecordInvalid.new(@favorite) }
			end
		end
	end

	def edit # :nodoc:
		@favorite = Shop::Favorite.acquire(params[:id])

		if @favorite.user_id != @current_user.id
			not_authorized
			return
		end

		respond_to do |format|
			format.html { render :layout => false if request.xhr? }
			format.xml  { render :xml => @favorite }
		end
	end

	def update # :nodoc:
		@favorite = Shop::Favorite.acquire(params[:id])

		if @favorite.user_id != @current_user.id
			not_authorized
			return
		end

		if @favorite.update_attributes(params[:favorite])
			respond_to do |format|
				format.html { redirect_to auction_favorite_path(@favorite) }
				format.xml { @data = { 'favorite' => @favorite } }
			end
		else
			respond_to do |format|
				format.html { render :action => :new }
				format.xml { raise ActiveRecord::RecordInvalid.new(@favorite) }
			end
		end
	end

	##
	# == 删除
	#
	# === Request
	#
	# ==== Resource
	#
	# DELETE /auction/favorites/:id
	#
	# ==== Parameters
	#
	# id :: 收藏ID
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
		@favorite = Shop::Favorite.acquire(params[:id])

		if @favorite.user_id != @current_user.id
			not_authorized
			return
		end

		@favorite.destroy_softly

		respond_to do |format|
			format.html { redirect_to auction_favorites_path }
			format.xml
		end
	end
end
