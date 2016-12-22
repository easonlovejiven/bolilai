##
# = 商城 收藏 界面
#
class Mobile::FavoritesController < Mobile::ApplicationController
	def index
		@favorites = @current_user.favorites.active._where(params[:where])._order(params[:order] || { :updated_at => 'DESC' }).page(params[:page]).per(params[:per_page] || 10)

		respond_to do |format|
			format.html
			format.xml { @data = { 'favorites' => @favorites } }
		end
	end
end
