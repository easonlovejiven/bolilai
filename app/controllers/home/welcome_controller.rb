# 欢迎页面
#
class Home::WelcomeController < Home::ApplicationController # :nodoc: all
  skip_before_action :login_filter, :except => [:update]

  def index
	end

	def new
		redirect_to '/welcome/11'
	end

	def show
		render :action => "show_#{params[:id]}"
	end

	def update
		college = Core::Affiliation.find_or_create_by_user_id_and_college_id(@current_user.id, params[:college_id].to_i) if params[:college_id]

		if params[:company_name]
			network = Core::Network.find_or_create_by_name(params[:company_name])
			Core::Affiliation.find_or_create_by_user_id_and_network_id(@current_user.id, network.id)
		end
		redirect_to "/welcome/41"
	end
end
